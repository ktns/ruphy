#include "extconf.h"
#include "ruby.h"
#ifdef HAVE_LIBINT2_H
#include "libint2.h"
#endif
#include "evaluator.h"

extern "C" {
  static VALUE return_true(){return Qtrue;};
  static VALUE return_false(){return Qfalse;};

  static void static_cleanup(VALUE p){
    LIBINT2_PREFIXED_NAME(libint2_static_cleanup)();
  }
}

static VALUE RuPHY;
static VALUE Libint2;

extern "C" void Init_ruphy_libint2(){
  RuPHY=rb_define_module("RuPHY");
  Libint2=rb_define_module_under(RuPHY,"Libint2");
#ifdef HAVE_LIBINT2_INIT_ERI
  rb_define_singleton_method(Libint2, "compiled?", RUBY_METHOD_FUNC(return_true),  0);
  rb_const_set(Libint2, rb_intern("MaxAM"), INT2NUM(LIBINT_MAX_AM));
  rb_const_set(Libint2, rb_intern("OptAM"), INT2NUM(LIBINT_OPT_AM));
#ifdef RUPHY_ENDPROC_VOID
  rb_set_end_proc((void*)static_cleanup, Qnil);
#elif defined(RUPHY_ENDPROC_FUNC)
  rb_set_end_proc((void(*)(VALUE))static_cleanup, Qnil);
#else
  rb_set_end_proc(static_cleanup, Qnil);
#endif
  LIBINT2_PREFIXED_NAME(libint2_static_init)();
  ruphy_libint2_define_evaluator(Libint2);
#else
  rb_define_singleton_method(Libint2, "compiled?", RUBY_METHOD_FUNC(return_false), 0);
#endif
}
/* vim: set et sw=2 : */
