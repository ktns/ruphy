#include "ruphy_gsl.h"
#include "spwf.h"
#include "spop.h"

#include <gsl/gsl_complex_math.h>

static VALUE rb_cOperated_Params;
static VALUE rb_cOperated_Func;

typedef struct {
	spwf_func  spwf;
	void      *spwf_params;
	spop_func  spop;
	void      *spop_params;
} owf_params;

static gsl_complex operated_wave_function(double r, double theta, double phi,
		void *arg_params)
{
	owf_params *params = arg_params;
	return params->spop(r, theta, phi,
			params->spop_params, params->spwf, params->spwf_params);
}

static VALUE get_func_operated(VALUE self)
{
	spwf_func *func    = ruby_xcalloc(1, sizeof(spwf_func));
	VALUE      wrapped = Data_Wrap_Struct(rb_cOperated_Func, NULL, free, func);
	*func = operated_wave_function;
	return wrapped;
}

static VALUE setup_owf_params(VALUE self, VALUE spop, VALUE spwf)
{
	owf_params *params = ruby_xcalloc(1, sizeof(owf_params));
	spwf_func *buf;
	get_func_param_from_spwf(spwf, &buf, &params->spwf_params);
	params->spwf = *buf;
	spop_func *spop_func_buf;
	get_func_param_from_spop(spop, &spop_func_buf, &params->spop_params);
	params->spop = *spop_func_buf;
	VALUE wrapped = Data_Wrap_Struct(rb_cOperated_Params, NULL, free, params);
	rb_iv_set(self, "params", wrapped);
	return wrapped;
}

GCC_ATTR_VISIBILITY_HIDDEN void init_SPWF_Operated(void)
{
	VALUE rb_cOperated  = rb_define_class_under(rb_mSPWF    , "Operated", rb_cObject);
	rb_cOperated_Params = rb_define_class_under(rb_cOperated, "Params"  , rb_cObject);
	rb_cOperated_Func   = rb_define_class_under(rb_cOperated, "Func"    , rb_cObject);

	rb_define_method(rb_cOperated, "get_func"    , get_func_operated, 0);
	rb_define_method(rb_cOperated, "setup_params", setup_owf_params , 2);
}
