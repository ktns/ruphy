#include "ruphy_gsl.h"
#include "spop.h"
#include "gsl_dummy_func.h"

#include <gsl/gsl_deriv.h>
#include <gsl/gsl_complex_math.h>

gsl_complex spop_r_deriv(double r, double theta, double phy, void *op_params, spwf_func spwf, void *wf_params) {
	gsl_function F;
	gsl_dummy_func_params params;
	gsl_complex res;
	double dummy;

	params.func     = spwf;
	params.variable = &params.r;
	params.theta    = theta;
	params.phy      = phy;
	params.params   = wf_params;

	F.function = gsl_dummy_func_real;
	F.params = &params;

	gsl_deriv_central(&F, r, DERIV_DX, &GSL_REAL(res), &dummy);

	F.function = gsl_dummy_func_imag;

	gsl_deriv_central(&F, r, DERIV_DX, &GSL_IMAG(res), &dummy);

	return res;
}

gsl_complex spop_theta_deriv(double r, double theta, double phy, void *op_params, spwf_func spwf, void *wf_params) {
	gsl_function F;
	gsl_dummy_func_params params;
	gsl_complex res;
	double dummy;

	params.func     = spwf;
	params.r        = r;
	params.variable = &params.theta;
	params.phy      = phy;
	params.params   = wf_params;

	F.function = gsl_dummy_func_real;
	F.params = &params;

	gsl_deriv_central(&F, theta, DERIV_DX, &GSL_REAL(res), &dummy);

	F.function = gsl_dummy_func_imag;

	gsl_deriv_central(&F, theta, DERIV_DX, &GSL_IMAG(res), &dummy);

	return res;
}

gsl_complex spop_phy_deriv(double r, double theta, double phy, void *op_params, spwf_func spwf, void *wf_params) {
	gsl_function F;
	gsl_dummy_func_params params;
	gsl_complex res;
	double dummy;

	params.func     = spwf;
	params.r        = r;
	params.theta    = theta;
	params.variable = &params.phy;
	params.params   = wf_params;

	F.function = gsl_dummy_func_real;
	F.params = &params;

	gsl_deriv_central(&F, phy, DERIV_DX, &GSL_REAL(res), &dummy);

	F.function = gsl_dummy_func_imag;

	gsl_deriv_central(&F, phy, DERIV_DX, &GSL_IMAG(res), &dummy);

	return res;
}

gsl_complex r_test_function(double r, double theta, double phy, void *params)
{
	return gsl_complex_rect(r,0);
}

VALUE test_deriv_r(VALUE self, VALUE arg_r) {
	double r = (double)NUM2DBL(arg_r);
	gsl_complex res = spop_r_deriv(r, 0, 0, NULL, r_test_function, NULL);
	return ruphy_gsl2rb_complex(&res);
}
