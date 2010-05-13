#include "ruphy_gsl.h"
#include "spwf.h"

#include <math.h>

#include <gsl/gsl_complex_math.h>
#include <gsl/gsl_math.h>
#include <gsl/gsl_pow_int.h>
#include <gsl/gsl_sf_gamma.h>
#include <gsl/gsl_sf_laguerre.h>
#include <gsl/gsl_sf_legendre.h>
#include <gsl/gsl_sf_pow_int.h>

static VALUE rb_cHydrogenic;
static VALUE rb_cHydrogenic_Params;
static VALUE rb_cHydrogenic_Func;

typedef struct _hwf_params {
	unsigned int n;
	unsigned int l;
	int          m;
	unsigned int Z;
} hwf_params;

static gsl_complex hydrogenic_wave_function(double r, double theta, double phy,
		void *params) {
	hwf_params *hwf_params = params;
	unsigned int n = hwf_params->n;
	unsigned int l = hwf_params->l;
	int          m = hwf_params->m;
	unsigned int Z = hwf_params->Z;
	return gsl_complex_mul_real( gsl_complex_exp (gsl_complex_rect(0, m * phy) ),
			sqrt( gsl_pow_3( 2*Z/n / gsl_sf_fact(n+l) ) * gsl_sf_fact(n-l-1) / 2 / n ) *
			exp(-r*Z/n) * gsl_sf_pow_int(r, l) * gsl_sf_laguerre_n (n+l, 2*l+1, 2*r*Z/n) *
			( m>0 && GSL_IS_ODD(m) ? -1 : 1 ) * gsl_sf_legendre_sphPlm(l, abs(m), cos(theta)));
}

static VALUE get_func_hydrogenic(VALUE self)
{
	spwf_func *func = ruby_xcalloc(1, sizeof(spwf_func));
	*func = hydrogenic_wave_function;
	VALUE wrapped = Data_Wrap_Struct(rb_cHydrogenic_Func, NULL, NULL, func);
	return wrapped;
}

static VALUE setup_hwf_params(VALUE self, VALUE n, VALUE l, VALUE m, VALUE Z)
{
	hwf_params *params = ruby_xcalloc(1, sizeof(hwf_params));
	params->n = NUM2INT(n);
	params->l = NUM2INT(l);
	params->m = NUM2INT(m);
	params->Z = NUM2INT(Z);
	VALUE wrapped = Data_Wrap_Struct(rb_cHydrogenic_Params, NULL, NULL, params);
	rb_iv_set(self, "params", wrapped);
	return wrapped;
}

void init_SPWF_Hydrogenic(void)
{
	rb_cHydrogenic        = rb_define_class_under(rb_mSPWF, "Hydrogenic", rb_cObject);
	rb_cHydrogenic_Params = rb_define_class_under(rb_cHydrogenic, "Params", rb_cObject);
	rb_cHydrogenic_Func   = rb_define_class_under(rb_cHydrogenic, "Func", rb_cObject);

	rb_define_method(rb_cHydrogenic, "get_func", get_func_hydrogenic, 0);
	rb_define_method(rb_cHydrogenic, "setup_params", setup_hwf_params, 4);
}
