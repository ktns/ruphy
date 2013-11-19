#include "extconf.h"
#include "ruby.h"
#ifdef HAVE_LIBINT2_H
#include "libint2.h"
#endif

static VALUE return_true(){return Qtrue;};
static VALUE return_false(){return Qfalse;};

static VALUE RuPHY;
static VALUE Libint2;

void Init_ruphy_libint2(){
	RuPHY=rb_define_module("RuPHY");
	Libint2=rb_define_module_under(RuPHY,"Libint2");
#ifdef HAVE_LIBINT2_INIT_ERI
	rb_define_singleton_method(Libint2, "compiled?", return_true,  0);
#else
	rb_define_singleton_method(Libint2, "compiled?", return_false, 0);
#endif
}
