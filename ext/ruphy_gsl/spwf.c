#include "ruphy_gsl.h"
#include "spwf.h"
#include "spwf_integrate.h"

#include <gsl/gsl_complex_math.h>

GCC_ATTR_VISIBILITY_HIDDEN VALUE rb_mSPWF;

GCC_ATTR_VISIBILITY_HIDDEN void get_func_param_from_spwf(VALUE spwf, spwf_func **func, void** params)
{
	Data_Get_Struct(rb_funcall(spwf, rb_intern("get_func"), 0), spwf_func, *func);
	Data_Get_Struct(rb_iv_get(spwf, "params"), void, *params);
}

#define RB_COMPLEX(ret) (rb_funcall(rb_mRuPHY, rb_intern("complex"), 2, rb_float_new(GSL_REAL(ret)), rb_float_new(GSL_IMAG(ret))))

static VALUE return_value(VALUE self, VALUE r, VALUE theta, VALUE phy) {
	void *params;
	spwf_func *func;
	get_func_param_from_spwf(self, &func, &params);
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

static VALUE inner_product(VALUE self, VALUE other)
{
	func_mul_with_conjugate_param_t params;
	spwf_func *func1  , *func2;
	get_func_param_from_spwf(self , &func1, &params.params1);
	get_func_param_from_spwf(other, &func2, &params.params2);
	params.func1 = *func1;
	params.func2 = *func2;
	gsl_complex ret = integrate_spwf(func_mul_with_conjugate, &params);
	return RB_COMPLEX(ret);
}

GCC_ATTR_VISIBILITY_HIDDEN void init_SPWF(void)
{
	rb_mSPWF  = rb_define_module_under(rb_mGSL, "SPWF");

	rb_define_method(rb_mSPWF, "eval"         , return_value , 3);
	rb_define_method(rb_mSPWF, "inner_product", inner_product, 1);

	init_SPWF_Hydrogenic();
	init_SPWF_Operated();
	init_SPWF_Combination();
}
