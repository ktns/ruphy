#include "extconf.h"
#include "ruby.h"
#ifdef HAVE_LIBINT2_H
#include "libint2.h"
#endif

static VALUE RuPHY;
static VALUE Libint2;
void Init_ruphy_libint2(){
	RuPHY=rb_define_module("RuPHY");
	Libint2=rb_define_module_under(RuPHY,"Libint2");
#ifdef HAVE_LIBINT2_INIT_ERI
#endif
}
