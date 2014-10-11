#pragma once
typedef struct _evaluator_struct{
  Libint_eri_t *erieval;
  LIBINT2_REALTYPE * buf;
}evaluator_struct;

#ifdef __cplusplus
extern "C"{
#endif
void ruphy_libint2_define_evaluator(VALUE libint2_module);
#ifdef __cplusplus
}
#endif
/* vim: set et sw=2 : */
