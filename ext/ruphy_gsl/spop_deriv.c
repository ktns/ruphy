#include "ruphy_gsl.h"
#include "spop.h"
#include "gsl_dummy_func.h"

#include <gsl/gsl_deriv.h>

#ifdef RUPHY_DERIV_TEST
#include <gsl/gsl_complex_math.h>
#endif //RUPHY_DERIV_TEST

GCC_ATTR_VISIBILITY_HIDDEN gsl_complex spop_r_deriv(double r, double theta, double phi, void *op_params, spwf_func spwf, void *wf_params) {
	gsl_function F;
	gsl_dummy_func_params params;
	gsl_complex res;
	double dummy;

	params.func     = spwf;
	params.variable = &params.r;
	params.theta    = theta;
	params.phi      = phi;
	params.params   = wf_params;

	F.function = gsl_dummy_func_real;
	F.params = &params;

	gsl_deriv_central(&F, r, DERIV_DX, &GSL_REAL(res), &dummy);

	F.function = gsl_dummy_func_imag;

	gsl_deriv_central(&F, r, DERIV_DX, &GSL_IMAG(res), &dummy);

	return res;
}

GCC_ATTR_VISIBILITY_HIDDEN gsl_complex spop_theta_deriv(double r, double theta, double phi, void *op_params, spwf_func spwf, void *wf_params) {
	gsl_function F;
	gsl_dummy_func_params params;
	gsl_complex res;
	double dummy;

	params.func     = spwf;
	params.r        = r;
	params.variable = &params.theta;
	params.phi      = phi;
	params.params   = wf_params;

	F.function = gsl_dummy_func_real;
	F.params = &params;

	gsl_deriv_central(&F, theta, DERIV_DX, &GSL_REAL(res), &dummy);

	F.function = gsl_dummy_func_imag;

	gsl_deriv_central(&F, theta, DERIV_DX, &GSL_IMAG(res), &dummy);

	return res;
}

GCC_ATTR_VISIBILITY_HIDDEN gsl_complex spop_phi_deriv(double r, double theta, double phi, void *op_params, spwf_func spwf, void *wf_params) {
	gsl_function F;
	gsl_dummy_func_params params;
	gsl_complex res;
	double dummy;

	params.func     = spwf;
	params.r        = r;
	params.theta    = theta;
	params.variable = &params.phi;
	params.params   = wf_params;

	F.function = gsl_dummy_func_real;
	F.params = &params;

	gsl_deriv_central(&F, phi, DERIV_DX, &GSL_REAL(res), &dummy);

	F.function = gsl_dummy_func_imag;

	gsl_deriv_central(&F, phi, DERIV_DX, &GSL_IMAG(res), &dummy);

	return res;
}

#ifdef RUPHY_DERIV_TEST

static gsl_complex r_test_function1(double r, double theta, double phi, void *params)
{
	return gsl_complex_rect(r,0);
}

static gsl_complex r_test_function2(double r, double theta, double phi, void *params)
{
	return gsl_complex_rect(r*r,0);
}

GCC_ATTR_VISIBILITY_HIDDEN VALUE test_deriv_r(VALUE self, VALUE index, VALUE arg_r) {
	static const spwf_func funcs[] = {r_test_function1, r_test_function2};

	double    r    = (double)NUM2DBL(arg_r);
	spwf_func func = funcs[FIX2INT(index)];

	gsl_complex res = spop_r_deriv(r, 0, 0, NULL, func, NULL);
	return ruphy_gsl2rb_complex(&res);
}

static gsl_complex theta_test_function1(double r, double theta, double phi, void *params)
{
	return gsl_complex_rect(theta,0);
}

static gsl_complex theta_test_function2(double r, double theta, double phi, void *params)
{
	return gsl_complex_rect(theta*theta,0);
}

GCC_ATTR_VISIBILITY_HIDDEN VALUE test_deriv_theta(VALUE self, VALUE index, VALUE arg_theta) {
	static const spwf_func funcs[] = {theta_test_function1, theta_test_function2};

	double    theta = (double)NUM2DBL(arg_theta);
	spwf_func func  = funcs[FIX2INT(index)];

	gsl_complex res = spop_theta_deriv(0, theta, 0, NULL, func, NULL);
	return ruphy_gsl2rb_complex(&res);
}

static gsl_complex phi_test_function1(double r, double theta, double phi, void *params)
{
	return gsl_complex_rect(phi,0);
}

static gsl_complex phi_test_function2(double r, double theta, double phi, void *params)
{
	return gsl_complex_rect(phi*phi,0);
}

GCC_ATTR_VISIBILITY_HIDDEN VALUE test_deriv_phi(VALUE self, VALUE index, VALUE arg_phi) {
	static const spwf_func funcs[] = {phi_test_function1, phi_test_function2};

	double    phi  = (double)NUM2DBL(arg_phi);
	spwf_func func = funcs[FIX2INT(index)];

	gsl_complex res = spop_phi_deriv(0, 0, phi, NULL, func, NULL);
	return ruphy_gsl2rb_complex(&res);
}

#endif //RUPHY_DERIV_TEST
