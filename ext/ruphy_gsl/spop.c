#include "ruphy_gsl.h"
#include "spop.h"

#include <gsl/gsl_complex_math.h>

static VALUE rb_mSPOP;
static VALUE rb_mHamiltonian;
static VALUE rb_cHydrogenic;

typedef struct {
	spop_func  potential_func;
	void      *potential_params;
}potential_params;

static gsl_complex hamiltonian(double r, double theta, double phy,
		void *op_params, spwf_func spwf, void *wf_params)
{
	potential_params *p_params = op_params;

	gsl_complex ret_laplacian =
		spop_laplacian(r, theta, phy, NULL, spwf, wf_params);

	gsl_complex ret_potential = p_params->potential_func(
			r, theta,phy, p_params->potential_params, spwf, wf_params);

	return gsl_complex_add(
			gsl_complex_div_real(ret_laplacian, 2), ret_potential);
}

void init_SPOP(void) {
	rb_mSPOP        = rb_define_module_under(rb_mGSL, "SPOP");
	rb_mHamiltonian = rb_define_module_under(rb_mSPOP, "Hamiltonian");
	rb_cHydrogenic  = rb_define_class_under(rb_mHamiltonian, "Hydrogenic", rb_cObject);
}
