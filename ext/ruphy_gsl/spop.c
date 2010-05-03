#include "ruphy_gsl.h"

static VALUE rb_cSPOP;

void init_SPOP(void) {
	rb_cSPOP = rb_define_class_under(rb_mGSL, "SPOP", rb_cObject);
}
