#include "ruphy_gsl.h"
#include "spwf.h"

static VALUE rb_cOperated_Params;
static VALUE rb_cOperated_Func;

typedef struct {
	spwf_func  spwf;
	void      *spwf_params;
	spop_func  spop;
	void      *spop_params;
} owf_params;

static gsl_complex operated_wave_function(double r, double theta, double phy,
		void *arg_params)
{
	owf_params *params = arg_params;
	return params->spop(r, theta, phy,
			params->spop_params, params->spwf, params->spwf_params);
}

static VALUE get_func_operated(VALUE self)
{
	spwf_func *func    = ruby_xcalloc(1, sizeof(spwf_func));
	VALUE      wrapped = Data_Wrap_Struct(rb_cOperated_Func, NULL, NULL, func);
	*func = operated_wave_function;
	return wrapped;
}

static VALUE setup_owf_params(VALUE self, VALUE spop, VALUE spwf)
{
	owf_params *params = ruby_xcalloc(1, sizeof(owf_params));
	spwf_func *buf;
	get_func_param(spwf, &buf, &params->spwf_params);
	params->spwf = *buf;
	VALUE wrapped = Data_Wrap_Struct(rb_cOperated_Params, NULL, NULL, params);
	rb_iv_set(self, "params", wrapped);
	return wrapped;
}

void init_SPWF_Operated(void)
{
	VALUE rb_cOperated  = rb_define_class_under(rb_mSPWF, "Operated", rb_cObject);
	rb_cOperated_Params = rb_define_class_under(rb_cOperated, "Params", rb_cObject);
	rb_cOperated_Func   = rb_define_class_under(rb_cOperated, "Func", rb_cObject);

	rb_define_method(rb_cOperated, "get_func"    , get_func_operated, 0);
	rb_define_method(rb_cOperated, "setup_params", setup_owf_params , 2);
}
