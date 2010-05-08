#include "ruphy_gsl.h"
#include "spop.h"

#include <gsl/gsl_math.h>
#include <gsl/gsl_complex_math.h>

typedef struct {
	spwf_func func;
	void * func_params;
}laplacian_dummy_params;

static gsl_complex laplacian_r_dummy (double  r, double theta, double phy, void *params) 
{
	laplacian_dummy_params *dummy_params = params;
	gsl_complex ret = spop_r_deriv(r, theta, phy, NULL,
			dummy_params->func, dummy_params->func_params);
	ret = gsl_complex_mul_real(ret, gsl_pow_2(r));
	return ret;
}

static gsl_complex laplacian_theta_dummy (double  r, double theta, double phy, void *params) 
{
	laplacian_dummy_params *dummy_params = params;
	gsl_complex ret = spop_theta_deriv(r, theta, phy, NULL,
			dummy_params->func, dummy_params->func_params);
	ret = gsl_complex_mul_real(ret, sin(theta));
	return ret;
}

static gsl_complex laplacian_phy_dummy (double  r, double theta, double phy, void *params) 
{
	laplacian_dummy_params *dummy_params = params;
	gsl_complex ret = spop_theta_deriv(r, theta, phy, NULL,
			dummy_params->func, dummy_params->func_params);
	return ret;
}

gsl_complex spop_laplacian (double  r, double theta, double phy, void *op_params, spwf_func spwf, void *wf_params )
{
	laplacian_dummy_params dummy_params;
	dummy_params.func        = spwf;
	dummy_params.func_params = wf_params;

	gsl_complex ret_r = spop_r_deriv(r, theta, phy,
			NULL, laplacian_r_dummy, &dummy_params);
	ret_r = gsl_complex_div_real(ret_r, gsl_pow_2(r));

	gsl_complex ret_theta = spop_theta_deriv(r, theta, phy,
			NULL, laplacian_theta_dummy, &dummy_params);
	ret_theta = gsl_complex_div_real(ret_theta, gsl_pow_2(r) * sin(theta));

	gsl_complex ret = gsl_complex_add(ret_r, ret_theta);

	gsl_complex ret_phy = spop_phy_deriv(r, theta, phy,
			NULL, laplacian_phy_dummy, &dummy_params);
	ret_phy = gsl_complex_div_real(ret_theta, gsl_pow_2(r * sin(theta)));

	ret = gsl_complex_add(ret, ret_phy);

	return ret;
}
