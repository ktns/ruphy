#include "ruphy_gsl.h"
#include "spop.h"

#include <gsl/gsl_complex_math.h>

static VALUE rb_cMultiplier;
static VALUE rb_cMultiplier_Func;
static VALUE rb_cMultiplier_Params;

static gsl_complex multiply(double r, double theta, double phi,
		void *op_params, spwf_func func, void *wf_params)
{
	gsl_complex *param=op_params;
	return gsl_complex_mul(func(r, theta, phi, wf_params), *param);
}

static VALUE get_multiplying_func(VALUE self)
{
	spop_func *func = ruby_xmalloc(sizeof(spop_func));
	*func = multiply;
	VALUE wrapped = Data_Wrap_Struct(rb_cMultiplier_Func, NULL, free, func);
	return wrapped;
}

static VALUE setup_multipler_params(VALUE self, VALUE real, VALUE imag)
{
	gsl_complex *params = ruby_xmalloc(sizeof(gsl_complex));
	*params = gsl_complex_rect(NUM2DBL(real), NUM2DBL(imag));
	VALUE wrapped = Data_Wrap_Struct(rb_cMultiplier_Params, NULL, free, params);
	rb_iv_set(self, "params", wrapped);
	return wrapped;
}

GCC_ATTR_VISIBILITY_HIDDEN void init_SPOP_Multiplier(void)
{
	rb_cMultiplier = rb_define_class_under(rb_mSPOP, "Multiplier", rb_cObject);

	rb_cMultiplier_Func   = rb_define_class_under(rb_cMultiplier, "Func"  , rb_cObject);
	rb_cMultiplier_Params = rb_define_class_under(rb_cMultiplier, "Params", rb_cObject);

	rb_define_method(rb_cMultiplier, "get_func"    , get_multiplying_func  , 0);
	rb_define_method(rb_cMultiplier, "setup_params", setup_multipler_params, 2);
}
