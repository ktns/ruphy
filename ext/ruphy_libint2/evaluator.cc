#include <ruby.h>
#include RUBY_EXTCONF_H

#ifdef HAVE_LIBINT2_H
#include <libint2.h>
#include "evaluator.h"

#define MAX(a,b) ((a)>(b)?(a):(b))

static VALUE evaluator_class;

static void free_libint_t(void *p){
  evaluator_struct *st = (evaluator_struct*)p;
  if(st->buf != NULL){
    ruby_xfree(st->buf);
  }
  if(st->erieval != NULL){
    delete []st->erieval;
  }
  ruby_xfree(st);
}

static VALUE new_method(VALUE self, VALUE args){
  VALUE ret;
  size_t buf_size;
  void *bufheap, *stheap = ALLOC(evaluator_struct);
  evaluator_struct *st = new(stheap) evaluator_struct;
  st->buf = NULL;
  st->erieval = NULL;
  ret = Data_Wrap_Struct(self, 0, free_libint_t, st);
  rb_apply(ret, rb_intern("initialize"), args); // this may not return due to exception
  st->max_am = NUM2UINT(rb_ivar_get(ret, rb_intern("@max_angular_momentum")));
  st->max_cd = NUM2UINT(rb_ivar_get(ret, rb_intern("@max_contrdepth")));
  buf_size = LIBINT2_PREFIXED_NAME(libint2_need_memory_eri)(st->max_am);
  bufheap = ruby_xmalloc(sizeof(LIBINT2_REALTYPE[buf_size]));
  st->erieval = new Libint_eri_t[st->max_cd];
  st->buf = new(bufheap) LIBINT2_REALTYPE[buf_size];
  LIBINT2_PREFIXED_NAME(libint2_init_eri)(&st->erieval[0], st->max_am, st->buf);
  return ret;
}

static VALUE packed_center_coordinates(VALUE evaluator){
  evaluator_struct* st;
  Data_Get_Struct(evaluator, evaluator_struct, st);
  return rb_str_new(st->centers.packed, sizeof(st->centers.packed));
}

static VALUE initialize_evaluator(VALUE evaluator){
  evaluator_struct* st;
  Data_Get_Struct(evaluator, evaluator_struct, st);
  st->Ax = NUM2DBL(rb_ivar_get(evaluator, rb_intern("@Ax")));
  st->Ay = NUM2DBL(rb_ivar_get(evaluator, rb_intern("@Ay")));
  st->Az = NUM2DBL(rb_ivar_get(evaluator, rb_intern("@Az")));
  st->Bx = NUM2DBL(rb_ivar_get(evaluator, rb_intern("@Bx")));
  st->By = NUM2DBL(rb_ivar_get(evaluator, rb_intern("@By")));
  st->Bz = NUM2DBL(rb_ivar_get(evaluator, rb_intern("@Bz")));
  st->Cx = NUM2DBL(rb_ivar_get(evaluator, rb_intern("@Cx")));
  st->Cy = NUM2DBL(rb_ivar_get(evaluator, rb_intern("@Cy")));
  st->Cz = NUM2DBL(rb_ivar_get(evaluator, rb_intern("@Cz")));
  st->Dx = NUM2DBL(rb_ivar_get(evaluator, rb_intern("@Dx")));
  st->Dy = NUM2DBL(rb_ivar_get(evaluator, rb_intern("@Dy")));
  st->Dz = NUM2DBL(rb_ivar_get(evaluator, rb_intern("@Dz")));
}

extern "C"
void ruphy_libint2_define_evaluator(VALUE libint2_module){
  evaluator_class = rb_define_class_under(libint2_module, "Evaluator", rb_cObject);
  rb_define_singleton_method(evaluator_class, "new", (VALUE(*)(...))new_method, -2);
  rb_define_method(evaluator_class, "initialize_evaluator", (VALUE(*)(...))initialize_evaluator, 0);
  rb_define_method(evaluator_class, "packed_center_coordinates", (VALUE(*)(...))packed_center_coordinates, 0);
}

#endif // HAVE_LIBINT2_H
/* vim: set et sw=2 : */
