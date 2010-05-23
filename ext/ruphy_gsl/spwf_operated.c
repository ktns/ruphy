#include "ruphy_gsl.h"
#include "spwf.h"

void init_SPWF_Operated(void)
{
	VALUE rb_cOperated = rb_define_class_under(rb_mSPWF, "Operated", rb_cObject);
}
