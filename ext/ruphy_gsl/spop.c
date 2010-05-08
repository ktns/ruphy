#include "ruphy_gsl.h"

#include "spop.h"

static VALUE rb_mSPOP;
static VALUE rb_mHamiltonian;
static VALUE rb_cHydrogenic;

void init_SPOP(void) {
	rb_mSPOP        = rb_define_module_under(rb_mGSL, "SPOP");
	rb_mHamiltonian = rb_define_module_under(rb_mSPOP, "Hamiltonian");
	rb_cHydrogenic  = rb_define_class_under(rb_mHamiltonian, "Hydrogenic", rb_cObject);
}
