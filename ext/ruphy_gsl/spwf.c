#include "ruphy_gsl.h"

static VALUE rb_cSPWF;
static VALUE rb_cHydrogenic;

void init_SPWF(void) {
	rb_cSPWF  = rb_define_class_under(rb_mGSL, "SPWF", rb_cObject);

	rb_cHydrogenic = rb_define_class_under(rb_cSPWF,"Hydrogenic", rb_cSPWF);
}
