#include "ruphy_gsl.h"
#include "spwf.h"

#include <math.h>

#include "cubature.h"

#include <gsl/gsl_pow_int.h>
#include <gsl/gsl_complex_math.h>
#include <gsl/gsl_errno.h>

typedef struct {
	spwf_func func;
	void *params;
} cubature_dummy_func_fdata_t;

static void cubature_dummy_func (unsigned ndim, const double *x, void * arg_fdata,
		unsigned fdim, double *fval)
{
	// TODO ndim should be 3 and fdim should be 2
	double t     = x[0];
	double r     = (1-t)/t;
	double theta = x[1];
	double phy   = x[2];

	cubature_dummy_func_fdata_t *fdata = arg_fdata;

	gsl_complex val = gsl_complex_mul_real(
			fdata->func(r, theta, phy, fdata->params),
			gsl_pow_2(r) * sin(theta) / gsl_pow_2(t)
			);

	fval[0] = GSL_REAL(val);
	fval[1] = GSL_IMAG(val);
}

#define REQERRABS (1.0e-8)
#define REQERRREL (1.0e-8)

gsl_complex integrate_spwf(spwf_func func, void *params)
{
	cubature_dummy_func_fdata_t fdata = {func, params};
	static const double xmin[3] = {0, 0, 0};
	static const double xmax[3] = {1, M_PI, 2 *M_PI};
	double ret[2], err[2];

	gsl_error_handler_t *original_handler = gsl_set_error_handler_off();

	adapt_integrate(
			2, cubature_dummy_func, &fdata,
			3, xmin, xmax,
			0, REQERRABS, REQERRREL,
			ret, err
			);

	gsl_set_error_handler(original_handler);

	return gsl_complex_rect(ret[0], ret[1]);
}
