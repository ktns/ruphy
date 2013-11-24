#include <ruby.h>
#include RUBY_EXTCONF_H

#ifdef HAVE_LIBINT2_H
#include <libint2.h>
#include "evaluator.h"

static VALUE evaluator_class;

static void free_libint_t(void * st){
	ruby_xfree(st);
}

static VALUE new(VALUE self, VALUE args){
	void* st = ruby_xmalloc(sizeof(Libint_t));
	VALUE ret = Data_Wrap_Struct(self, 0, free_libint_t, st);
	rb_apply(ret, rb_intern("initialize"), args);
	return ret;
}

void ruphy_libint2_define_evaluator(VALUE libint2_module){
	evaluator_class = rb_define_class_under(libint2_module, "Evaluator", rb_cObject);
	rb_define_singleton_method(evaluator_class, "new", new, -2);
}

#endif // HAVE_LIBINT2_H
