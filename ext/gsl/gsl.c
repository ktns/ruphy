#include "gsl.h"

void Init_gsl()
{
	rb_mRuPHY = rb_define_module("RuPHY");
	rb_mGSL   = rb_define_module_under(rb_mRuPHY, "GSL");
	rb_cSPWF  = rb_define_class_under(rb_mGSL, "SPWF", rb_cObject);
}
