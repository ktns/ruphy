#pragma once
typedef struct _evaluator_struct{
  Libint_eri_t *erieval;
  LIBINT2_REALTYPE * buf;
  unsigned int tot_am, max_am, max_cd;
  union{
    struct{
      double Ax, Ay, Az, Bx, By, Bz, Cx, Cy, Cz, Dx, Dy, Dz;
    }coords;
    char packed[sizeof(coords)];
  }centers;
  double &Ax, &Ay, &Az, &Bx, &By, &Bz, &Cx, &Cy, &Cz, &Dx, &Dy, &Dz;
  _evaluator_struct(void) :
    Ax(centers.coords.Ax),
    Ay(centers.coords.Ay),
    Az(centers.coords.Az),
    Bx(centers.coords.Bx),
    By(centers.coords.By),
    Bz(centers.coords.Bz),
    Cx(centers.coords.Cx),
    Cy(centers.coords.Cy),
    Cz(centers.coords.Cz),
    Dx(centers.coords.Dx),
    Dy(centers.coords.Dy),
    Dz(centers.coords.Dz){
    }
}evaluator_struct;

#ifdef __cplusplus
extern "C"{
#endif
void ruphy_libint2_define_evaluator(VALUE libint2_module);
#ifdef __cplusplus
}
#endif
/* vim: set et sw=2 : */
