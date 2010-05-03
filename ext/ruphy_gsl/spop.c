#include "ruphy_gsl.h"

static VALUE rb_cSPOP;
static VALUE rb_cHamiltonian;
static VALUE rb_cHydrogenic;

void init_SPOP(void) {
	rb_cSPOP        = rb_define_class_under(rb_mGSL, "SPOP", rb_cObject);
	rb_cHamiltonian = rb_define_class_under(rb_cSPOP, "Hamiltonian", rb_cSPOP);
	rb_cHydrogenic  = rb_define_class_under(rb_cHamiltonian, "Hydrogenic", rb_cHamiltonian);
}
