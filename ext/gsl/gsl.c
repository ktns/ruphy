#include <ruby.h>

static VALUE rb_mRuPHY;
static VALUE rb_mGSL;

void Init_gsl()
{
	rb_mRuPHY = rb_define_module("RuPHY");
	rb_mGSL   = rb_define_module_under(rb_mRuPHY, "GSL");
}
