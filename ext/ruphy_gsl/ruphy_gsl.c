#include "ruphy_gsl.h"
#include "spwf.h"
#include "spop.h"

#include <gsl/gsl_errno.h>

VALUE rb_mRuPHY;
VALUE rb_mGSL;
VALUE rb_cGSLError;

static VALUE rb_mGSLERRNO;

static void gsl_errror_handler(const char *reason, const char *file, int line, int gsl_errno)
{
	VALUE exc_arg[4] = { rb_str_new2(reason), rb_str_new2(file), rb_int_new(line), rb_int_new(gsl_errno)};

	VALUE exc = rb_class_new_instance(4, exc_arg, rb_cGSLError);

	rb_exc_raise(exc);
}

static VALUE gsl_errorstr(VALUE self, VALUE _errno)
{
	return rb_str_new2(gsl_strerror(FIX2INT(_errno)));
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
	rb_mGSLERRNO = rb_define_module_under(rb_cGSLError, "Errno");

	rb_define_const(rb_mGSLERRNO, "GSL_SUCCESS" , rb_int_new(GSL_SUCCESS));
	rb_define_const(rb_mGSLERRNO, "GSL_FAILURE" , rb_int_new(GSL_FAILURE));
	rb_define_const(rb_mGSLERRNO, "GSL_CONTINUE", rb_int_new(GSL_CONTINUE));
	rb_define_const(rb_mGSLERRNO, "GSL_EDOM"    , rb_int_new(GSL_EDOM));
	rb_define_const(rb_mGSLERRNO, "GSL_ERANGE"  , rb_int_new(GSL_ERANGE));
	rb_define_const(rb_mGSLERRNO, "GSL_EFAULT"  , rb_int_new(GSL_EFAULT));
	rb_define_const(rb_mGSLERRNO, "GSL_EINVAL"  , rb_int_new(GSL_EINVAL));
	rb_define_const(rb_mGSLERRNO, "GSL_EFAILED" , rb_int_new(GSL_EFAILED));
	rb_define_const(rb_mGSLERRNO, "GSL_EFACTOR" , rb_int_new(GSL_EFACTOR));
	rb_define_const(rb_mGSLERRNO, "GSL_ESANITY" , rb_int_new(GSL_ESANITY));
	rb_define_const(rb_mGSLERRNO, "GSL_ENOMEM"  , rb_int_new(GSL_ENOMEM));
	rb_define_const(rb_mGSLERRNO, "GSL_EBADFUNC", rb_int_new(GSL_EBADFUNC));
	rb_define_const(rb_mGSLERRNO, "GSL_ERUNAWAY", rb_int_new(GSL_ERUNAWAY));
	rb_define_const(rb_mGSLERRNO, "GSL_EMAXITER", rb_int_new(GSL_EMAXITER));
	rb_define_const(rb_mGSLERRNO, "GSL_EZERODIV", rb_int_new(GSL_EZERODIV));
	rb_define_const(rb_mGSLERRNO, "GSL_EBADTOL" , rb_int_new(GSL_EBADTOL));
	rb_define_const(rb_mGSLERRNO, "GSL_ETOL"    , rb_int_new(GSL_ETOL));
	rb_define_const(rb_mGSLERRNO, "GSL_EUNDRFLW", rb_int_new(GSL_EUNDRFLW));
	rb_define_const(rb_mGSLERRNO, "GSL_EOVRFLW" , rb_int_new(GSL_EOVRFLW));
	rb_define_const(rb_mGSLERRNO, "GSL_ELOSS"   , rb_int_new(GSL_ELOSS));
	rb_define_const(rb_mGSLERRNO, "GSL_EROUND"  , rb_int_new(GSL_EROUND));
	rb_define_const(rb_mGSLERRNO, "GSL_EBADLEN" , rb_int_new(GSL_EBADLEN));
	rb_define_const(rb_mGSLERRNO, "GSL_ENOTSQR" , rb_int_new(GSL_ENOTSQR));
	rb_define_const(rb_mGSLERRNO, "GSL_ESING"   , rb_int_new(GSL_ESING));
	rb_define_const(rb_mGSLERRNO, "GSL_EDIVERGE", rb_int_new(GSL_EDIVERGE));
	rb_define_const(rb_mGSLERRNO, "GSL_EUNSUP"  , rb_int_new(GSL_EUNSUP));
	rb_define_const(rb_mGSLERRNO, "GSL_EUNIMPL" , rb_int_new(GSL_EUNIMPL));
	rb_define_const(rb_mGSLERRNO, "GSL_ECACHE"  , rb_int_new(GSL_ECACHE));
	rb_define_const(rb_mGSLERRNO, "GSL_ETABLE"  , rb_int_new(GSL_ETABLE));
	rb_define_const(rb_mGSLERRNO, "GSL_ENOPROG" , rb_int_new(GSL_ENOPROG));
	rb_define_const(rb_mGSLERRNO, "GSL_ENOPROGJ", rb_int_new(GSL_ENOPROGJ));
	rb_define_const(rb_mGSLERRNO, "GSL_ETOLF"   , rb_int_new(GSL_ETOLF));
	rb_define_const(rb_mGSLERRNO, "GSL_ETOLX"   , rb_int_new(GSL_ETOLX));
	rb_define_const(rb_mGSLERRNO, "GSL_ETOLG"   , rb_int_new(GSL_ETOLG));
	rb_define_const(rb_mGSLERRNO, "GSL_EOF"     , rb_int_new(GSL_EOF));

	rb_define_method(rb_mGSLERRNO, "errorstr", gsl_errorstr, 1);

#ifdef RUPHY_GSL_ERROR_TEST
	rb_define_singleton_method(rb_cGSLError, "gsl_error_test", gsl_error_test, 0);
#endif //RUPHY_GSL_ERROR_TEST

	gsl_set_error_handler(gsl_errror_handler);

	init_SPWF();
	init_SPOP();
}
