#include "ruphy_gsl.h"
#include "spop.h"

#include <math.h>
#include <gsl/gsl_math.h>
#include <gsl/gsl_sf_trig.h>

static VALUE rb_cFunc;
static VALUE rb_cParams;

typedef struct {
	double dx;
	double dy;
	double dz;
}trnsl_params;

static gsl_complex translate(double r, double theta, double phy,
		void *op_params, spwf_func func, void *wf_params)
{
	trnsl_params *params = op_params;
	double x,y,z;
	x = r * sin(theta) * cos(phy) + params->dx;
	y = r * sin(theta) * sin(phy) + params->dy;
	z = r * cos(theta)            + params->dz;
	r = sqrt(gsl_pow_2(x) + gsl_pow_2(y) + gsl_pow_2(z));
	theta = acos(z/r);
	gsl_sf_result r_res;
	gsl_sf_result theta_res;
	gsl_sf_rect_to_polar(x, y, &r_res, &theta_res);
	phy = theta_res.val;

	return func(r, theta, phy, wf_params);
}

static VALUE get_trnsl_func(VALUE self)
{
	spop_func *func = ruby_xmalloc(sizeof(spop_func));
	*func = translate;
	VALUE wrapped = Data_Wrap_Struct(rb_cParams, NULL, free, func);
	return wrapped;
}

static VALUE setup_trnsl_params(VALUE self, VALUE dx, VALUE dy, VALUE dz)
{
	trnsl_params *params = ruby_xmalloc(sizeof(trnsl_params));
	params->dx = NUM2DBL(dx);
	params->dy = NUM2DBL(dy);
	params->dz = NUM2DBL(dz);
	VALUE wrapped = Data_Wrap_Struct(rb_cParams, NULL, free, params);
	rb_iv_set(self, "params", wrapped);
	return wrapped;
}

GCC_ATTR_VISIBILITY_HIDDEN void init_SPOP_Translation(void)
{
	VALUE rb_cTranslation = rb_define_class_under(rb_mSPOP, "Translation", rb_cObject);

	rb_cFunc   = rb_define_class_under(rb_cTranslation, "Func"  , rb_cObject);
	rb_cParams = rb_define_class_under(rb_cTranslation, "Params", rb_cObject);

	rb_define_method(rb_cTranslation, "get_func"    , get_trnsl_func    , 0);
	rb_define_method(rb_cTranslation, "setup_params", setup_trnsl_params, 3);
}
