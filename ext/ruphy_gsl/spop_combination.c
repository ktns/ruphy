#include "ruphy_gsl.h"
#include "spop.h"

#include <gsl/gsl_complex_math.h>

static VALUE rb_cFunc;
static VALUE rb_cParams;

typedef struct {
	int         n;
	spop_func  *funcs;
	void      **params;
}cop_params;

static gsl_complex cop(double r, double theta, double phi,
		void *op_params, spwf_func func, void *wf_params)
{
	cop_params *params = op_params;
	gsl_complex ret = gsl_complex_rect(0,0);
	int i;
	for(i=0; i < params->n; i++){
		ret = gsl_complex_add(ret,
				params->funcs[i](r, theta, phi, params->params[i], func, wf_params));
	}
	return ret;
}

static VALUE get_cop_func(VALUE self)
{
	spop_func *func = ruby_xmalloc(sizeof(spop_func));
	*func = cop;
	VALUE wrapped = Data_Wrap_Struct(rb_cParams, NULL, free, func);
	return wrapped;
}

static void free_cop_params(void *st)
{
	cop_params *params = st;
	free(params->funcs);
	free(params->params);
	free(st);
}

static VALUE setup_cop_params(int argc, VALUE *argv, VALUE self)
{
	cop_params *params = ruby_xmalloc(sizeof(cop_params));
	params->funcs = ruby_xcalloc(argc, sizeof(spop_func));
	params->params = ruby_xcalloc(argc, sizeof(void*));
	params->n = argc;
	int i;
	for(i=0; i < argc; i++){
		spop_func *buf;
		get_func_param_from_spop(argv[i], &buf, &params->params[i]);
		params->funcs[i] = *buf;
	}
	VALUE wrapped = Data_Wrap_Struct(rb_cParams, NULL, free_cop_params, params);
	rb_iv_set(self, "params", wrapped);
	return wrapped;
}

GCC_ATTR_VISIBILITY_HIDDEN void init_SPOP_Combination(void)
{
	VALUE rb_cCombination = rb_define_class_under(rb_mSPOP, "Combination", rb_cObject);

	rb_cFunc   = rb_define_class_under(rb_cCombination, "Func"  , rb_cObject);
	rb_cParams = rb_define_class_under(rb_cCombination, "Params", rb_cObject);

	rb_define_method(rb_cCombination, "get_func"    , get_cop_func  , 0);
	rb_define_method(rb_cCombination, "setup_params", setup_cop_params, -1);
}
