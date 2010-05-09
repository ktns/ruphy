#include "ruphy_gsl.h"

#include <math.h>

#include <gsl/gsl_complex_math.h>
#include <gsl/gsl_math.h>
#include <gsl/gsl_pow_int.h>
#include <gsl/gsl_sf_gamma.h>
#include <gsl/gsl_sf_laguerre.h>
#include <gsl/gsl_sf_legendre.h>
#include <gsl/gsl_sf_pow_int.h>

static VALUE rb_mSPWF;

static VALUE rb_cHydrogenic;

typedef struct _hwf_params {
	unsigned int n;
	unsigned int l;
	int          m;
	unsigned int Z;
} hwf_params;

typedef {
	spwf_func func;
	hwf_params param;
} hwf_func_params;

static gsl_complex hydrogenic_wave_function(double r, double theta, double phy,
		hwf_params *params) {
	unsigned int n = params->n;
	unsigned int l = params->l;
	int          m = params->m;
	unsigned int Z = params->Z;
	return gsl_complex_mul_real( gsl_complex_exp (gsl_complex_rect(0, m * phy) ),
			sqrt( gsl_pow_3( 2*Z/n / gsl_sf_fact(n+l) ) * gsl_sf_fact(n-l-1) / 2 / n ) *
			exp(-r*Z) * gsl_sf_pow_int(r, l) * gsl_sf_laguerre_n (n+1, 2l+1, 2*r*Z) *
			( m>0 ? 2*GSL_IS_EVEN(m)-1 : 1 ) * gsl_sf_legendre_sphPlm(l, abs(m), cos(theta)));
}

static VALUE return_value(VALUE self, VALUE r, VALUE theta, VALUE phy) {
	hwf_params params;
	params.n = NUM2INT(rb_iv_get(self, "@n"));
	params.l = NUM2INT(rb_iv_get(self, "@l"));
	params.m = NUM2INT(rb_iv_get(self, "@m"));
	params.Z = NUM2INT(rb_iv_get(self, "@Z"));
	gsl_complex ret = hydrogenic_wave_function(rb_num2dbl(r), rb_num2dbl(theta), rb_num2dbl(phy),&params);
	return rb_funcall(rb_mRuPHY, rb_intern("complex"), 2, rb_float_new(GSL_REAL(ret)), rb_float_new(GSL_IMAG(ret)));
}

void init_SPWF(void) {
	rb_mSPWF  = rb_define_module_under(rb_mGSL, "SPWF");

	rb_cHydrogenic = rb_define_class_under(rb_mSPWF, "Hydrogenic", rb_cObject);

	rb_define_method(rb_cHydrogenic, "eval", return_value, 3);
}
