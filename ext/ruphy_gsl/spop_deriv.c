#include "ruphy_gsl.h"
#include "spop.h"

#include <gsl/gsl_deriv.h>

typedef struct {
	spwf_func func;
	double x1,x2;
	void *params;
} dummy_params;

static double r_deriv_dummy_real(double r, void *arg_params) {
	dummy_params* params=arg_params;
	return GSL_REAL(params->func(r, params->x1, params->x2, params->params));
}

static double r_deriv_dummy_imag(double r, void *arg_params) {
	dummy_params* params=arg_params;
	return GSL_IMAG(params->func(r, params->x1, params->x2, params->params));
}

static double theta_deriv_dummy_real(double theta, void *arg_params) {
	dummy_params* params=arg_params;
	return GSL_REAL(params->func(params->x2, theta, params->x1, params->params));
}

static double theta_deriv_dummy_imag(double theta, void *arg_params) {
	dummy_params* params=arg_params;
	return GSL_IMAG(params->func(params->x2, theta, params->x1, params->params));
}

static double phy_deriv_dummy_real(double phy, void *arg_params) {
	dummy_params* params=arg_params;
	return GSL_REAL(params->func(params->x1, params->x2, phy, params->params));
}

static double phy_deriv_dummy_imag(double phy, void *arg_params) {
	dummy_params* params=arg_params;
	return GSL_IMAG(params->func(params->x1, params->x2, phy, params->params));
}

gsl_complex spop_r_deriv(double r, double theta, double phy, void *op_params, spwf_func spwf, void *wf_params) {
	gsl_function F;
	dummy_params params;
	gsl_complex res;
	double dummy;

	params.func   = spwf;
	params.x1     = theta;
	params.x2     = phy;
	params.params = wf_params;

	F.function = r_deriv_dummy_real;
	F.params = &params;

	gsl_deriv_central(&F, r, DERIV_DX, &GSL_REAL(res), &dummy);

	F.function = r_deriv_dummy_imag;

	gsl_deriv_central(&F, r, DERIV_DX, &GSL_IMAG(res), &dummy);

	return res;
}

gsl_complex spop_theta_deriv(double r, double theta, double phy, void *op_params, spwf_func spwf, void *wf_params) {
	gsl_function F;
	dummy_params params;
	gsl_complex res;
	double dummy;

	params.func   = spwf;
	params.x1     = phy;
	params.x2     = r;
	params.params = wf_params;

	F.function = theta_deriv_dummy_real;
	F.params = &params;

	gsl_deriv_central(&F, theta, DERIV_DX, &GSL_REAL(res), &dummy);

	F.function = theta_deriv_dummy_imag;

	gsl_deriv_central(&F, theta, DERIV_DX, &GSL_IMAG(res), &dummy);

	return res;
}

gsl_complex spop_phy_deriv(double r, double theta, double phy, void *op_params, spwf_func spwf, void *wf_params) {
	gsl_function F;
	dummy_params params;
	gsl_complex res;
	double dummy;

	params.func   = spwf;
	params.x1     = r;
	params.x2     = theta;
	params.params = wf_params;

	F.function = phy_deriv_dummy_real;
	F.params = &params;

	gsl_deriv_central(&F, phy, DERIV_DX, &GSL_REAL(res), &dummy);

	F.function = phy_deriv_dummy_imag;

	gsl_deriv_central(&F, phy, DERIV_DX, &GSL_IMAG(res), &dummy);

	return res;
}
