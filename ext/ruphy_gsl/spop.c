#include "ruphy_gsl.h"

static VALUE rb_cSPOP;
static VALUE rb_cHamiltonian;
static VALUE rb_cHydrogenic;

#define DERIV_DX (1e-8)

typedef struct {
	spwf_func func;
	double x1,x2;
	void *params;
} dummy_params;

double r_deriv_dummy_real(double r, dummy_params *params) {
	return GSL_REAL(params->func(r, params->x1, params->x2, params->params));
}

double r_deriv_dummy_imag(double r, dummy_params *params) {
	return GSL_IMAG(params->func(r, params->x1, params->x2, params->params));
}

double theta_deriv_dummy_real(double theta, dummy_params *params) {
	return GSL_REAL(params->func(params->x2, theta, params->x1, params->params));
}

double theta_deriv_dummy_imag(double theta, dummy_params *params) {
	return GSL_IMAG(params->func(params->x2, theta, params->x1, params->params));
}

double phy_deriv_dummy_real(double phy, dummy_params *params) {
	return GSL_REAL(params->func(params->x1, params->x2, phy, params->params));
}

double phy_deriv_dummy_imag(double phy, dummy_params *params) {
	return GSL_IMAG(params->func(params->x1, params->x2, phy, params->params));
}

void init_SPOP(void) {
	rb_cSPOP        = rb_define_class_under(rb_mGSL, "SPOP", rb_cObject);
	rb_cHamiltonian = rb_define_class_under(rb_cSPOP, "Hamiltonian", rb_cSPOP);
	rb_cHydrogenic  = rb_define_class_under(rb_cHamiltonian, "Hydrogenic", rb_cHamiltonian);
}
