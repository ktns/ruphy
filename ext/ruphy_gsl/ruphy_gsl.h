#include <ruby.h>
#include <gsl/gsl_complex.h>

extern VALUE rb_mRuPHY;
extern VALUE rb_mGSL;

typedef gsl_complex(*spwf_func)(double r, double theta, double phy, void *params);
typedef gsl_complex(*spop_func)(double r, double theta, double phy, void *op_params, spwf_func spwf, void *wf_params);

VALUE ruphy_gsl2rb_complex(const gsl_complex* orig);
