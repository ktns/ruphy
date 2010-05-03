#include "ruphy_gsl.h"

VALUE ruphy_gsl2rb_complex(const gsl_complex* orig) {
	return rb_funcall(rb_mRuPHY, rb_intern("complex"), 2, rb_float_new(GSL_REAL((*orig))), rb_float_new(GSL_IMAG((*orig))));
}
