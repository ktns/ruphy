#include "ruphy_gsl.h"
#include "spwf.h"

VALUE rb_mSPWF;

static void get_func_param(VALUE spwf, spwf_func **func, void** params)
{
	Data_Get_Struct(rb_funcall(spwf, rb_intern("get_func"), 0), spwf_func, *func);
	Data_Get_Struct(rb_iv_get(spwf, "params"), void, *params);
}

static VALUE return_value(VALUE self, VALUE r, VALUE theta, VALUE phy) {
	void *params;
	spwf_func *func;
	get_func_param(self, &func, &params);
	gsl_complex ret = (*func)(rb_num2dbl(r), rb_num2dbl(theta), rb_num2dbl(phy),params);
	return rb_funcall(rb_mRuPHY, rb_intern("complex"), 2, rb_float_new(GSL_REAL(ret)), rb_float_new(GSL_IMAG(ret)));
}

void init_SPWF(void) {
	rb_mSPWF  = rb_define_module_under(rb_mGSL, "SPWF");

	rb_define_method(rb_mSPWF, "eval", return_value, 3);

	init_SPWF_Hydrogenic();
}
