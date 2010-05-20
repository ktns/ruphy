#include "ruphy_gsl.h"
#include "spwf.h"
#include "spop.h"

#include <gsl/gsl_errno.h>

VALUE rb_mRuPHY;
VALUE rb_mGSL;
VALUE rb_cGSLError;

static void gsl_errror_handler(const char *reason, const char *file, int line, int gsl_errno)
{
	VALUE exc_arg[4] = { rb_str_new2(reason), rb_str_new2(file), rb_int_new(line), rb_int_new(gsl_errno)};

	VALUE exc = rb_class_new_instance(4, exc_arg, rb_cGSLError);

	rb_exc_raise(exc);
}

#ifdef RUPHY_GSL_ERROR_TEST
static VALUE gsl_error_test(VALUE self)
{
	GSL_ERROR("test", GSL_EINVAL);
}
#endif //RUPHY_GSL_ERROR_TEST


static int loaded = 0;

void Init_ruphy_gsl()
{
	if(loaded)
		return;
	loaded = 1;
	rb_mRuPHY    = rb_define_module("RuPHY");
	rb_mGSL      = rb_define_module_under(rb_mRuPHY, "GSL");
	rb_cGSLError = rb_define_class_under(rb_mGSL, "GSLError", rb_eException);

#ifdef RUPHY_GSL_ERROR_TEST
	rb_define_singleton_method(rb_cGSLError, "gsl_error_test", gsl_error_test, 0);
#endif //RUPHY_GSL_ERROR_TEST

	gsl_set_error_handler(gsl_errror_handler);

	init_SPWF();
	init_SPOP();
}
