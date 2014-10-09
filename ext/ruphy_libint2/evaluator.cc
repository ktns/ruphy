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
	unsigned int max_am, max_cd;
	size_t buf_size;
	void *heap;
	evaluator_struct *st = ALLOC(evaluator_struct);
	st->buf = NULL;
	st->erieval = NULL;
	ret = Data_Wrap_Struct(self, 0, free_libint_t, st);
	rb_apply(ret, rb_intern("initialize"), args); // this may not return due to exception
	max_am = NUM2UINT(rb_ivar_get(ret, rb_intern("@max_angular_momentum")));
	max_cd = NUM2UINT(rb_ivar_get(ret, rb_intern("@max_contrdepth")));
	buf_size = LIBINT2_PREFIXED_NAME(libint2_need_memory_eri)(max_am);
	heap = ruby_xmalloc(sizeof(LIBINT2_REALTYPE[buf_size]));
	st->erieval = new Libint_eri_t[max_cd];
	st->buf = new(heap) LIBINT2_REALTYPE[buf_size];
	LIBINT2_PREFIXED_NAME(libint2_init_eri)(&st->erieval[0], max_am, st->buf);
	return ret;
}

extern "C"
void ruphy_libint2_define_evaluator(VALUE libint2_module){
	evaluator_class = rb_define_class_under(libint2_module, "Evaluator", rb_cObject);
	rb_define_singleton_method(evaluator_class, "new", (VALUE(*)(...))new_method, -2);
	rb_define_attr(evaluator_class, "max_angular_momentum", true, false);
}

#endif // HAVE_LIBINT2_H
