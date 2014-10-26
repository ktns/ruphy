#pragma once
typedef struct _evaluator_struct{
  Libint_eri_t *erieval;
  LIBINT2_REALTYPE * buf;
  unsigned int max_tot_am, max_am, max_cd;
  union{
    struct{
      double Ax, Ay, Az, Bx, By, Bz, Cx, Cy, Cz, Dx, Dy, Dz;
    }coords;
    char packed[sizeof(coords)];
  }centers;
}evaluator_struct;

#ifdef __cplusplus
extern "C"{
#endif
void ruphy_libint2_define_evaluator(VALUE libint2_module);
#ifdef __cplusplus
}
#endif
/* vim: set et sw=2 : */
