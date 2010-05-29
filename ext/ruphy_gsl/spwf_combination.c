#include "ruphy_gsl.h"
#include "spwf.h"

void init_SPWF_Combination(void)
{
	VALUE rb_cCombination = rb_define_class_under(rb_mSPWF, "Combination", rb_cObject);
}
