#include <ruby.h>
#include <gsl/gsl_complex.h>

#include "extconf.h"

#if __GNUC__ >= 4
#define GCC_ATTR_VISIBILITY_HIDDEN __attribute__ ((visibility("hidden")))
#else
#define GCC_ATTR_VISIBILITY_HIDDEN
#endif

extern VALUE rb_mRuPHY;
extern VALUE rb_mGSL;
extern VALUE rb_cGSLError;

typedef gsl_complex(*spwf_func)(double r, double theta, double phy, void *params);
typedef gsl_complex(*spop_func)(double r, double theta, double phy, void *op_params, spwf_func spwf, void *wf_params);

VALUE ruphy_gsl2rb_complex(const gsl_complex* orig);
