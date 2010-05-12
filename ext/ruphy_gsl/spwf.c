#include "ruphy_gsl.h"
#include "spwf.h"
#include "gsl_dummy_func.h"

#include <gsl/gsl_complex_math.h>
#include <gsl/gsl_integration.h>

VALUE rb_mSPWF;

static void get_func_param(VALUE spwf, spwf_func **func, void** params)
{
	Data_Get_Struct(rb_funcall(spwf, rb_intern("get_func"), 0), spwf_func, *func);
	Data_Get_Struct(rb_iv_get(spwf, "params"), void, *params);
}

#define RB_COMPLEX(ret) (rb_funcall(rb_mRuPHY, rb_intern("complex"), 2, rb_float_new(GSL_REAL(ret)), rb_float_new(GSL_IMAG(ret))))

static VALUE return_value(VALUE self, VALUE r, VALUE theta, VALUE phy) {
	void *params;
	spwf_func *func;
	get_func_param(self, &func, &params);
	gsl_complex ret = (*func)(rb_num2dbl(r), rb_num2dbl(theta), rb_num2dbl(phy),params);
	return RB_COMPLEX(ret);
}

typedef struct {
	spwf_func func1; void *params1;
	spwf_func func2; void *params2;
}func_mul_with_conjugate_param_t;


static gsl_complex func_mul_with_conjugate(double r, double theta, double phy, void *params_arg)
{
	func_mul_with_conjugate_param_t *params = params_arg;
	return gsl_complex_mul(
			gsl_complex_conjugate(params->func1(r, theta, phy, params->params1)),
			params->func2(r, theta, phy,params->params2));
}

#define QAG_WORKSPACE_SIZE (0x100)
#define QAG_EPSABS         (1.0e-8)
#define QAG_EPSREL         (1.0e-8)
#define QAG_RULE_KEY       (GSL_INTEG_GAUSS61)

typedef struct {
	spwf_func func;
	void *params;
	double r;
} integration_params;

static gsl_integration_workspace *qag_workspace_phy;

double integrate_spwf_phy_real(double theta, void *arg_params)
{
	integration_params *params = arg_params;
	gsl_function F;
	gsl_dummy_func_params dummy_params;
	double ret;
	double dummy;

	dummy_params.r        = params->r;
	dummy_params.theta    = theta;
	dummy_params.variable = &dummy_params.phy;
	dummy_params.func     = params->func;
	dummy_params.params   = params->params;

	F.function = gsl_dummy_func_real;
	F.params   = &dummy_params;

	gsl_integration_qag(&F, - M_PI, M_PI,
			QAG_EPSABS, QAG_EPSABS, QAG_WORKSPACE_SIZE, QAG_RULE_KEY,
			qag_workspace_phy, &ret, &dummy);

	return ret * sin(theta);
}

double integrate_spwf_phy_imag(double theta, void *arg_params)
{
	integration_params *params = arg_params;
	gsl_function F;
	gsl_dummy_func_params dummy_params;
	double ret;
	double dummy;

	dummy_params.r        = params->r;
	dummy_params.theta    = theta;
	dummy_params.variable = &dummy_params.phy;
	dummy_params.func     = params->func;
	dummy_params.params   = params->params;

	F.function = gsl_dummy_func_imag;
	F.params   = &dummy_params;

	gsl_integration_qag(&F, - M_PI, M_PI,
			QAG_EPSABS, QAG_EPSABS, QAG_WORKSPACE_SIZE, QAG_RULE_KEY,
			qag_workspace_phy, &ret, &dummy);

	return ret * sin(theta);
}

static gsl_integration_workspace *qag_workspace_theta;

double integrate_spwf_theta_real(double r, void *arg_params)
{
	integration_params *params = arg_params;
	gsl_function F;
	double ret, dummy;

	params->r = r;

	F.function = integrate_spwf_phy_real;
	F.params   = arg_params;

	gsl_integration_qag(&F, 0, M_PI,
			QAG_EPSABS, QAG_EPSREL, QAG_WORKSPACE_SIZE, QAG_RULE_KEY,
			qag_workspace_theta, &ret, &dummy);

	return ret * gsl_pow_2(r);
}

double integrate_spwf_theta_imag(double r, void *arg_params)
{
	integration_params *params = arg_params;
	gsl_function F;
	double ret, dummy;

	params->r = r;

	F.function = integrate_spwf_phy_imag;
	F.params   = arg_params;

	gsl_integration_qag(&F, 0, M_PI,
			QAG_EPSABS, QAG_EPSREL, QAG_WORKSPACE_SIZE, QAG_RULE_KEY,
			qag_workspace_theta, &ret, &dummy);

	return ret * gsl_pow_2(r);
}

static gsl_integration_workspace *qag_workspace_r;

double integrate_spwf_r_real(double r1, double r2, void *arg_params)
{
	gsl_function F;
	double ret, dummy;

	F.function = integrate_spwf_theta_real;
	F.params   = arg_params;

	gsl_integration_qag(&F, r1, r2,
			QAG_EPSABS, QAG_EPSREL, QAG_WORKSPACE_SIZE, QAG_RULE_KEY,
			qag_workspace_theta, &ret, &dummy);

	return ret;
}

double integrate_spwf_r_imag(double r1, double r2, void *arg_params)
{
	gsl_function F;
	double ret, dummy;

	F.function = integrate_spwf_theta_imag;
	F.params   = arg_params;

	gsl_integration_qag(&F, r1, r2,
			QAG_EPSABS, QAG_EPSREL, QAG_WORKSPACE_SIZE, QAG_RULE_KEY,
			qag_workspace_theta, &ret, &dummy);

	return ret;
}

#define INTEGRATE_DR (1.0)

gsl_complex integrate_spwf(spwf_func func, void *arg_params)
{
	double r;
	gsl_complex ret, diff;
	integration_params params;

	params.params = arg_params;
	params.func = func;

	for(r = 0, ret = GSL_COMPLEX_ZERO, diff = GSL_COMPLEX_ZERO;
			r == 0 || gsl_complex_abs(diff) /
			gsl_complex_abs(ret) > QAG_EPSREL; r += INTEGRATE_DR){
		diff = gsl_complex_rect(
				integrate_spwf_r_real(r, r+INTEGRATE_DR, &params),
				integrate_spwf_r_imag(r, r+INTEGRATE_DR, &params));
		ret = gsl_complex_add(ret, diff);
	}
	return ret;
}

static VALUE inner_product(VALUE self, VALUE other)
{
	func_mul_with_conjugate_param_t params;
	spwf_func *func1  , *func2;
	get_func_param(self, &func1, &params.params1);
	get_func_param(self, &func2, &params.params2);
	params.func1 = *func1;
	params.func2 = *func2;
	gsl_complex ret = integrate_spwf(func_mul_with_conjugate, &params);
	return RB_COMPLEX(ret);
}

void init_SPWF(void) {
	rb_mSPWF  = rb_define_module_under(rb_mGSL, "SPWF");

	rb_define_method(rb_mSPWF, "eval"         , return_value , 3);
	rb_define_method(rb_mSPWF, "inner_product", inner_product, 1);

	VALUE rb_cQAG_WorkSpace_t = rb_define_class_under(rb_mSPWF, "QAG_WorkSpace_t", rb_cObject);
	qag_workspace_r = gsl_integration_workspace_alloc(QAG_WORKSPACE_SIZE);
	rb_const_set(rb_mSPWF, rb_intern("QAG_WorkSpace_R"), Data_Wrap_Struct(
				rb_cQAG_WorkSpace_t, 0, gsl_integration_workspace_free, qag_workspace_r));
	qag_workspace_theta = gsl_integration_workspace_alloc(QAG_WORKSPACE_SIZE);
	rb_const_set(rb_mSPWF, rb_intern("QAG_WorkSpace_Theta"), Data_Wrap_Struct(
				rb_cQAG_WorkSpace_t, 0, gsl_integration_workspace_free, qag_workspace_theta));
	qag_workspace_phy = gsl_integration_workspace_alloc(QAG_WORKSPACE_SIZE);
	rb_const_set(rb_mSPWF, rb_intern("QAG_WorkSpace_Phy"), Data_Wrap_Struct(
				rb_cQAG_WorkSpace_t, 0, gsl_integration_workspace_free, qag_workspace_phy));

	init_SPWF_Hydrogenic();
}
