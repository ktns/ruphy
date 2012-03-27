#include "ruphy_gsl.h"
#include "gsl_dummy_func.h"

GCC_ATTR_VISIBILITY_HIDDEN double gsl_dummy_func_real(double x, void *arg_params)
{
	gsl_dummy_func_params* params=arg_params;
	*params->variable = x;
	return GSL_REAL(params->func(params->r, params->theta, params->phi, params->params));
}

GCC_ATTR_VISIBILITY_HIDDEN double gsl_dummy_func_imag(double x, void *arg_params)
{
	gsl_dummy_func_params* params=arg_params;
	*params->variable = x;
	return GSL_IMAG(params->func(params->r, params->theta, params->phi, params->params));
}
