#include "gsl.h"

static VALUE rb_cSPWF;

void init_SPWF(void) {
	rb_cSPWF  = rb_define_class_under(rb_mGSL, "SPWF", rb_cObject);
}
