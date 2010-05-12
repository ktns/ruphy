#include "ruphy_gsl.h"
#include "spwf.h"
#include "gsl_dummy_func.h"

#include <gsl/gsl_complex_math.h>
#include <gsl/gsl_integration.h>


#define QAG_WORKSPACE_SIZE (0x100)
#define QAG_EPSABS         (1.0e-8)
#define QAG_EPSREL         (1.0e-8)
#define QAG_RULE_KEY       (GSL_INTEG_GAUSS61)

typedef struct {
	spwf_func func;
	void *params;
	double r;
	double error;
} integration_params;

static gsl_integration_workspace *qag_workspace_phy;

static double integrate_spwf_phy_real(double theta, void *arg_params)
{
	integration_params *params = arg_params;
	gsl_function F;
	gsl_dummy_func_params dummy_params;
	double ret;
	double error;

	dummy_params.r        = params->r;
	dummy_params.theta    = theta;
	dummy_params.variable = &dummy_params.phy;
	dummy_params.func     = params->func;
	dummy_params.params   = params->params;

	F.function = gsl_dummy_func_real;
	F.params   = &dummy_params;

	gsl_integration_qag(&F, - M_PI, M_PI,
			QAG_EPSABS, QAG_EPSABS, QAG_WORKSPACE_SIZE, QAG_RULE_KEY,
			qag_workspace_phy, &ret, &error);

	params->error+=error;
	return ret * sin(theta);
}

static double integrate_spwf_phy_imag(double theta, void *arg_params)
{
	integration_params *params = arg_params;
	gsl_function F;
	gsl_dummy_func_params dummy_params;
	double ret;
	double error;

	dummy_params.r        = params->r;
	dummy_params.theta    = theta;
	dummy_params.variable = &dummy_params.phy;
	dummy_params.func     = params->func;
	dummy_params.params   = params->params;

	F.function = gsl_dummy_func_imag;
	F.params   = &dummy_params;

	gsl_integration_qag(&F, - M_PI, M_PI,
			QAG_EPSABS, QAG_EPSABS, QAG_WORKSPACE_SIZE, QAG_RULE_KEY,
			qag_workspace_phy, &ret, &error);

	params->error+=error;
	return ret * sin(theta);
}

static gsl_integration_workspace *qag_workspace_theta;

static double integrate_spwf_theta_real(double r, void *arg_params)
{
	integration_params *params = arg_params;
	gsl_function F;
	double ret, error;

	params->r = r;

	F.function = integrate_spwf_phy_real;
	F.params   = arg_params;

	gsl_integration_qag(&F, 0, M_PI,
			QAG_EPSABS, QAG_EPSREL, QAG_WORKSPACE_SIZE, QAG_RULE_KEY,
			qag_workspace_theta, &ret, &error);

	params->error+=error;
	return ret * gsl_pow_2(r);
}

static double integrate_spwf_theta_imag(double r, void *arg_params)
{
	integration_params *params = arg_params;
	gsl_function F;
	double ret, error;

	params->r = r;

	F.function = integrate_spwf_phy_imag;
	F.params   = arg_params;

	gsl_integration_qag(&F, 0, M_PI,
			QAG_EPSABS, QAG_EPSREL, QAG_WORKSPACE_SIZE, QAG_RULE_KEY,
			qag_workspace_theta, &ret, &error);

	params->error+=error;
	return ret * gsl_pow_2(r);
}

static gsl_integration_workspace *qag_workspace_r;

static double integrate_spwf_r_real(double r1, double r2, void *arg_params)
{
	integration_params *params = arg_params;
	gsl_function F;
	double ret, error;

	F.function = integrate_spwf_theta_real;
	F.params   = arg_params;

	gsl_integration_qag(&F, r1, r2,
			QAG_EPSABS, QAG_EPSREL, QAG_WORKSPACE_SIZE, QAG_RULE_KEY,
			qag_workspace_theta, &ret, &error);

	params->error+=error;
	return ret;
}

static double integrate_spwf_r_imag(double r1, double r2, void *arg_params)
{
	integration_params *params = arg_params;
	gsl_function F;
	double ret, error;

	F.function = integrate_spwf_theta_imag;
	F.params   = arg_params;

	gsl_integration_qag(&F, r1, r2,
			QAG_EPSABS, QAG_EPSREL, QAG_WORKSPACE_SIZE, QAG_RULE_KEY,
			qag_workspace_theta, &ret, &error);

	params->error+=error;
	return ret;
}

#define INTEGRATE_DR (1.0)

gsl_complex integrate_spwf(spwf_func func, void *arg_params)
{
	double r;
	gsl_complex ret, diff;
	integration_params params;

	params.error  = 0;
	params.params = arg_params;
	params.func   = func;

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

void init_SPWF_Integrate(VALUE rb_mSPWF)
{
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
}
