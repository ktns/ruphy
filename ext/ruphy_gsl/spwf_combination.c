#include "ruphy_gsl.h"
#include "spwf.h"

#include <gsl/gsl_complex_math.h>

static VALUE rb_cComboParams;
static VALUE rb_cComboFunc;

typedef struct {
		spwf_func  func;
		void      *params;
}func_params;

typedef struct {
	int count;
	func_params *params;
}combo_params;

static gsl_complex combo_wave_function(
		double r, double theta, double phi, void *arg_params)
{
	gsl_complex buf = gsl_complex_rect(0,0);
	combo_params *params = arg_params;
	int i;
	for(i = 0; i < params->count; i++) {
		buf = gsl_complex_add(buf,
				params->params[i].func(r, theta, phi, params->params[i].params));
	}
	return buf;
}

static VALUE get_combo_func(VALUE self)
{
	spwf_func *func = ruby_xmalloc(sizeof(spwf_func));
	*func = combo_wave_function;
	VALUE wrapped = Data_Wrap_Struct(rb_cComboFunc, NULL, free, func);
	return wrapped;
}

static void free_combo_params(void *st)
{
	combo_params *params = st;
	free(params->params);
	free(st);
}

static VALUE setup_combo_params(int argc, VALUE *argv, VALUE self)
{
	int i;
	combo_params *params = ruby_xmalloc(sizeof(combo_params));
	params->params = ruby_xcalloc(argc, sizeof(func_params));
	params->count  = argc;
	for(i=0; i<argc; i++) {
		spwf_func *buf;
		get_func_param_from_spwf(argv[i], &buf, &params->params[i].params);
		params->params[i].func = *buf;
	}
	VALUE wrapped = Data_Wrap_Struct(rb_cComboParams, NULL, free_combo_params, params);
	rb_iv_set(self, "params", wrapped);
	return wrapped;
}

GCC_ATTR_VISIBILITY_HIDDEN void init_SPWF_Combination(void)
{
	VALUE rb_cCombination = rb_define_class_under(rb_mSPWF , "Combination", rb_cObject);
	rb_cComboParams = rb_define_class_under(rb_cCombination, "Params"     , rb_cObject);
	rb_cComboFunc   = rb_define_class_under(rb_cCombination, "Func"       , rb_cObject);

	rb_define_method(rb_cCombination, "setup_params", setup_combo_params, -1);
	rb_define_method(rb_cCombination, "get_func"    , get_combo_func    , 0);
}
