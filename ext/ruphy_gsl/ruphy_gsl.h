#include <ruby.h>
#include <gsl/gsl_complex.h>

VALUE rb_mRuPHY;
VALUE rb_mGSL;

void init_SPWF(void);
void init_SPOP(void);

VALUE ruphy_gsl2rb_complex(const gsl_complex* orig);
