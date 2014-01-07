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
	ruby_xfree(st);
}

static VALUE new_method(VALUE self, VALUE args){
	VALUE ret;
	unsigned int max_am;
	size_t buf_size;
	void *heap;
	evaluator_struct *st = ALLOC(evaluator_struct);
	st->buf = NULL;
	ret = Data_Wrap_Struct(self, 0, free_libint_t, st);
	rb_apply(ret, rb_intern("initialize"), args); // this may not return due to exception
	max_am = NUM2UINT(rb_ivar_get(ret, rb_intern("@max_angular_momentum")));
	buf_size = LIBINT2_PREFIXED_NAME(libint2_need_memory_eri)(max_am);
	heap = ruby_xmalloc(sizeof(LIBINT2_REALTYPE[buf_size]));
	st->buf = new(heap) LIBINT2_REALTYPE[buf_size];
	LIBINT2_PREFIXED_NAME(libint2_init_eri)(&st->erieval, max_am, st->buf);
	return ret;
}

static VALUE initialize(VALUE self, VALUE shell1, VALUE shell2, VALUE shell3, VALUE shell4){
	unsigned int max_am = 0;
	rb_ivar_set(self, rb_intern("@shells"), rb_ary_new3(4, shell1, shell2, shell3, shell4));
	VALUE empty_ary = rb_ary_new();
	max_am = MAX(max_am, NUM2UINT(rb_apply(shell1, rb_intern("angular_momentum"), empty_ary)));
	max_am = MAX(max_am, NUM2UINT(rb_apply(shell2, rb_intern("angular_momentum"), empty_ary)));
	max_am = MAX(max_am, NUM2UINT(rb_apply(shell3, rb_intern("angular_momentum"), empty_ary)));
	max_am = MAX(max_am, NUM2UINT(rb_apply(shell4, rb_intern("angular_momentum"), empty_ary)));
	rb_ivar_set(self, rb_intern("@max_angular_momentum"), UINT2NUM(max_am));
	return self;
}

extern "C"
void ruphy_libint2_define_evaluator(VALUE libint2_module){
	evaluator_class = rb_define_class_under(libint2_module, "Evaluator", rb_cObject);
	rb_define_method(evaluator_class, "initialize", (VALUE(*)(...))initialize, 4);
	rb_define_singleton_method(evaluator_class, "new", (VALUE(*)(...))new_method, -2);
	rb_define_attr(evaluator_class, "max_angular_momentum", true, false);
}

#endif // HAVE_LIBINT2_H
