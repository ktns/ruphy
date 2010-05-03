#include "ruphy_gsl.h"

#include <math.h>

#include <gsl/gsl_complex.h>
#include <gsl/gsl_complex_math.h>
#include <gsl/gsl_math.h>
#include <gsl/gsl_pow_int.h>
#include <gsl/gsl_sf_gamma.h>
#include <gsl/gsl_sf_laguerre.h>
#include <gsl/gsl_sf_legendre.h>
#include <gsl/gsl_sf_pow_int.h>

static VALUE rb_cSPWF;

static VALUE rb_cHydrogenic;

static gsl_complex hydrogenic_wave_function(double r, double theta, double phy,
		unsigned int n, unsigned int l, int m, unsigned int Z) {
	return gsl_complex_mul_real( gsl_complex_exp (gsl_complex_rect(0, m * phy) ),
			sqrt( gsl_pow_3( 2*Z/n / gsl_sf_fact(n+l) ) * gsl_sf_fact(n-l-1) / 2 / n ) *
			exp(-r*Z) * gsl_sf_pow_int(r, l) * gsl_sf_laguerre_n (n+1, 2l+1, 2*r*Z) *
			( m>0 ? 2*GSL_IS_EVEN(m)-1 : 1 ) * gsl_sf_legendre_sphPlm(l, abs(m), cos(theta)));
}

void init_SPWF(void) {
	rb_cSPWF  = rb_define_class_under(rb_mGSL, "SPWF", rb_cObject);

	rb_cHydrogenic = rb_define_class_under(rb_cSPWF,"Hydrogenic", rb_cSPWF);
}
