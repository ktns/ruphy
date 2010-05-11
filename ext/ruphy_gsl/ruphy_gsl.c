#include "ruphy_gsl.h"
#include "spwf.h"
#include "spop.h"

VALUE rb_mRuPHY;
VALUE rb_mGSL;

void Init_ruphy_gsl()
{
	rb_mRuPHY = rb_define_module("RuPHY");
	rb_mGSL   = rb_define_module_under(rb_mRuPHY, "GSL");
	init_SPWF();
	init_SPOP();
}
