/*
 *  This file is a part of RuPHY.
 *  Copyright (C) 2004-2014 Edward F. Valeev
 *  Copyright (C) 2013-2014 Katsuhiko Nishimra
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see http://www.gnu.org/licenses/.
 *
 */

#include <utility>

#include <ruby.h>
#include RUBY_EXTCONF_H

#ifdef HAVE_LIBINT2_H
#include <libint2.h>
#include <libint2/boys.h>
#include <libint2/cgshell_ordering.h>
#include "evaluator.h"

static libint2::FmEval_Chebyshev3 fmeval_chebyshev(LIBINT_MAX_AM*4 + 2);

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
  st->tot_am = NUM2UINT(rb_ivar_get(ret, rb_intern("@total_azimuthal_quantum_number")));
  st->max_am = NUM2UINT(rb_ivar_get(ret, rb_intern("@max_azimuthal_quantum_number")));
  st->max_cd = NUM2UINT(rb_ivar_get(ret, rb_intern("@max_contrdepth")));
  buf_size = LIBINT2_PREFIXED_NAME(libint2_need_memory_eri)(st->max_am);
  bufheap = ruby_xmalloc(sizeof(LIBINT2_REALTYPE[buf_size]));
  st->erieval = new Libint_eri_t[st->max_cd];
  st->buf = new(bufheap) LIBINT2_REALTYPE[buf_size];
  LIBINT2_PREFIXED_NAME(libint2_init_eri)(&st->erieval[0], st->max_am, st->buf);
  st->erieval[0].contrdepth=0;
  return ret;
}

static VALUE packed_center_coordinates(VALUE evaluator){
  evaluator_struct* st;
  Data_Get_Struct(evaluator, evaluator_struct, st);
  return rb_str_new(st->centers.packed, sizeof(st->centers.packed));
}

static VALUE initialize_evaluator_primitive(VALUE, VALUE evaluator, int argc, VALUE argv[]){
  if(argc != 6)
    rb_raise(rb_const_get(rb_cObject, rb_intern("ArgumentError")), "Libint2::Evaluator#initialize_evaluator_primitive: Expected 6 arguments, but %d!", argc);
  unsigned int i = NUM2UINT(argv[0]);
  const double c = NUM2DBL(argv[1]),
               alpha0 = NUM2DBL(argv[2]),
               alpha1 = NUM2DBL(argv[3]),
               alpha2 = NUM2DBL(argv[4]),
               alpha3 = NUM2DBL(argv[5]);
  evaluator_struct *st;
  Data_Get_Struct(evaluator, evaluator_struct, st);
  Libint_eri_t *erieval = &st->erieval[i];
  const double gammap = alpha0 + alpha1, gammaq = alpha2 + alpha3,
        oogammap = 1.0 / gammap,  oogammaq = 1.0 / gammaq,
        one_o_gammap_plus_gammaq = 1.0 / (gammap + gammaq),
        gammapq = gammap * gammaq * one_o_gammap_plus_gammaq,
        gammap_o_gammapgammaq = gammapq * oogammaq,
        gammaq_o_gammapgammaq = gammapq * oogammap,
        rhop = alpha0 * alpha1 * oogammap,
        rhoq = alpha2 * alpha3 * oogammaq,
        Ax = st->centers.coords.Ax, Bx = st->centers.coords.Bx,
        Ay = st->centers.coords.Ay, By = st->centers.coords.By,
        Az = st->centers.coords.Az, Bz = st->centers.coords.Bz,
        Cx = st->centers.coords.Cx, Dx = st->centers.coords.Dx,
        Cy = st->centers.coords.Cy, Dy = st->centers.coords.Dy,
        Cz = st->centers.coords.Cz, Dz = st->centers.coords.Dz,
        Px = (alpha0 * Ax + alpha1 * Bx ) * oogammap,
        Py = (alpha0 * Ay + alpha1 * By ) * oogammap,
        Pz = (alpha0 * Az + alpha1 * Bz ) * oogammap,
        Qx = (alpha2 * Cx + alpha3 * Dx ) * oogammaq,
        Qy = (alpha2 * Cy + alpha3 * Dy ) * oogammaq,
        Qz = (alpha2 * Cz + alpha3 * Dz ) * oogammaq,
        Wx = (gammap_o_gammapgammaq * Px + gammaq_o_gammapgammaq * Qx),
        Wy = (gammap_o_gammapgammaq * Py + gammaq_o_gammapgammaq * Qy),
        Wz = (gammap_o_gammapgammaq * Pz + gammaq_o_gammapgammaq * Qz),
        AB2 = (Ax-Bx) * (Ax-Bx) + (Ay-By) * (Ay-By) + (Az-Bz) * (Az-Bz),
        CD2 = (Cx-Dx) * (Cx-Dx) + (Cy-Dy) * (Cy-Dy) + (Cz-Dz) * (Cz-Dz),
        PQ2 = (Px-Qx) * (Px-Qx) + (Py-Qy) * (Py-Qy) + (Pz-Qz) * (Pz-Qz);
  erieval->veclen=1;
#if LIBINT2_DEFINED(eri, PA_x)
  erieval->PA_x[0] = Px - Ax;
#endif
#if LIBINT2_DEFINED(eri, PA_y)
  erieval->PA_y[0] = Py - Ay;
#endif
#if LIBINT2_DEFINED(eri, PA_z)
  erieval->PA_z[0] = Pz - Az;
#endif
#if LIBINT2_DEFINED(eri, PB_x)
  erieval->PB_x[0] = Px - Bx;
#endif
#if LIBINT2_DEFINED(eri, PB_y)
  erieval->PB_y[0] = Py - By;
#endif
#if LIBINT2_DEFINED(eri, PB_z)
  erieval->PB_z[0] = Pz - Bz;
#endif
#if LIBINT2_DEFINED(eri, AB_x)
  erieval->AB_x[0] = Ax - Bx;
#endif
#if LIBINT2_DEFINED(eri, AB_y)
  erieval->AB_y[0] = Ay - By;
#endif
#if LIBINT2_DEFINED(eri, AB_z)
  erieval->AB_z[0] = Az - Bz;
#endif
#if LIBINT2_DEFINED(eri, BA_x)
  erieval->BA_x[0] = Bx - Ax;
#endif
#if LIBINT2_DEFINED(eri, BA_y)
  erieval->BA_y[0] = By - Ay;
#endif
#if LIBINT2_DEFINED(eri, BA_z)
  erieval->BA_z[0] = Bz - Az;
#endif
#if LIBINT2_DEFINED(eri, oo2z)
  erieval->oo2z[0] = 0.5*oogammap;
#endif
#if LIBINT2_DEFINED(eri, QC_x)
  erieval->QC_x[0] = Qx - Cx;
#endif
#if LIBINT2_DEFINED(eri, QC_y)
  erieval->QC_y[0] = Qy - Cy;
#endif
#if LIBINT2_DEFINED(eri, QC_z)
  erieval->QC_z[0] = Qz - Cz;
#endif
#if LIBINT2_DEFINED(eri, QD_x)
  erieval->QD_x[0] = Qx - Dx;
#endif
#if LIBINT2_DEFINED(eri, QD_y)
  erieval->QD_y[0] = Qy - Dy;
#endif
#if LIBINT2_DEFINED(eri, QD_z)
  erieval->QD_z[0] = Qz - Dz;
#endif
#if LIBINT2_DEFINED(eri, CD_x)
  erieval->CD_x[0] = Cx - Dx;
#endif
#if LIBINT2_DEFINED(eri, CD_y)
  erieval->CD_y[0] = Cy - Dy;
#endif
#if LIBINT2_DEFINED(eri, CD_z)
  erieval->CD_z[0] = Cz - Dz;
#endif
#if LIBINT2_DEFINED(eri, DC_x)
  erieval->DC_x[0] = Dx - Cx;
#endif
#if LIBINT2_DEFINED(eri, DC_y)
  erieval->DC_y[0] = Dy - Cy;
#endif
#if LIBINT2_DEFINED(eri, DC_z)
  erieval->DC_z[0] = Dz - Cz;
#endif
#if LIBINT2_DEFINED(eri, oo2e)
  erieval->oo2e[0] = 0.5*oogammaq;
#endif

  // Prefactors for interelectron transfer relation
#if LIBINT2_DEFINED(eri,TwoPRepITR_pfac0_0_0_x)
  erieval->TwoPRepITR_pfac0_0_0_x[0] = - (alpha1*AB_x + alpha3*CD_x)*oogammap;
#endif
#if LIBINT2_DEFINED(eri,TwoPRepITR_pfac0_0_0_y)
  erieval->TwoPRepITR_pfac0_0_0_y[0] = - (alpha1*AB_y + alpha3*CD_y)*oogammap;
#endif
#if LIBINT2_DEFINED(eri,TwoPRepITR_pfac0_0_0_z)
  erieval->TwoPRepITR_pfac0_0_0_z[0] = - (alpha1*AB_z + alpha3*CD_z)*oogammap;
#endif
#if LIBINT2_DEFINED(eri,TwoPRepITR_pfac0_1_0_x)
  erieval->TwoPRepITR_pfac0_1_0_x[0] = - (alpha1*AB_x + alpha3*CD_x)*oogammaq;
#endif
#if LIBINT2_DEFINED(eri,TwoPRepITR_pfac0_1_0_y)
  erieval->TwoPRepITR_pfac0_1_0_y[0] = - (alpha1*AB_y + alpha3*CD_y)*oogammaq;
#endif
#if LIBINT2_DEFINED(eri,TwoPRepITR_pfac0_1_0_z)
  erieval->TwoPRepITR_pfac0_1_0_z[0] = - (alpha1*AB_z + alpha3*CD_z)*oogammaq;
#endif
#if LIBINT2_DEFINED(eri,TwoPRepITR_pfac0_0_1_x)
  erieval->TwoPRepITR_pfac0_0_1_x[0] = (alpha0*AB_x + alpha2*CD_x)*oogammap;
#endif
#if LIBINT2_DEFINED(eri,TwoPRepITR_pfac0_0_1_y)
  erieval->TwoPRepITR_pfac0_0_1_y[0] = (alpha0*AB_y + alpha2*CD_y)*oogammap;
#endif
#if LIBINT2_DEFINED(eri,TwoPRepITR_pfac0_0_1_z)
  erieval->TwoPRepITR_pfac0_0_1_z[0] = (alpha0*AB_z + alpha2*CD_z)*oogammap;
#endif
#if LIBINT2_DEFINED(eri,TwoPRepITR_pfac0_1_1_x)
  erieval->TwoPRepITR_pfac0_1_1_x[0] = (alpha0*AB_x + alpha2*CD_x)*oogammaq;
#endif
#if LIBINT2_DEFINED(eri,TwoPRepITR_pfac0_1_1_y)
  erieval->TwoPRepITR_pfac0_1_1_y[0] = (alpha0*AB_y + alpha2*CD_y)*oogammaq;
#endif
#if LIBINT2_DEFINED(eri,TwoPRepITR_pfac0_1_1_z)
  erieval->TwoPRepITR_pfac0_1_1_z[0] = (alpha0*AB_z + alpha2*CD_z)*oogammaq;
#endif
#if LIBINT2_DEFINED(eri,eoz)
  erieval->eoz[0] = gammaq*oogammap;
#endif
#if LIBINT2_DEFINED(eri,zoe)
  erieval->zoe[0] = gammap*oogammaq;
#endif

#if LIBINT2_DEFINED(eri,WP_x)
  erieval->WP_x[0] = Wx - Px;
#endif
#if LIBINT2_DEFINED(eri,WP_y)
  erieval->WP_y[0] = Wy - Py;
#endif
#if LIBINT2_DEFINED(eri,WP_z)
  erieval->WP_z[0] = Wz - Pz;
#endif
#if LIBINT2_DEFINED(eri,WQ_x)
  erieval->WQ_x[0] = Wx - Qx;
#endif
#if LIBINT2_DEFINED(eri,WQ_y)
  erieval->WQ_y[0] = Wy - Qy;
#endif
#if LIBINT2_DEFINED(eri,WQ_z)
  erieval->WQ_z[0] = Wz - Qz;
#endif
#if LIBINT2_DEFINED(eri,oo2ze)
  erieval->oo2ze[0] = 0.5/(gammap+gammaq);
#endif
#if LIBINT2_DEFINED(eri,roz)
  erieval->roz[0] = gammapq*oogammap;
#endif
#if LIBINT2_DEFINED(eri,roe)
  erieval->roe[0] = gammapq*oogammaq;
#endif

  const double K1 = exp(- rhop * AB2) * oogammap;
  const double K2 = exp(- rhoq * CD2) * oogammaq;
  const double two_times_M_PI_to_25 = 34.986836655249725693;
  const double pfac = c * two_times_M_PI_to_25 * K1 * K2 * sqrt(one_o_gammap_plus_gammaq);
  double F[LIBINT_MAX_AM*4 + 6] = {};
  fmeval_chebyshev.eval(F, PQ2*gammapq, st->tot_am);
#if LIBINT2_DEFINED(eri,LIBINT_T_SS_EREP_SS(0))
  erieval->LIBINT_T_SS_EREP_SS(0)[0] = pfac*F[0];
#endif
#if LIBINT2_DEFINED(eri,LIBINT_T_SS_EREP_SS(1))
  erieval->LIBINT_T_SS_EREP_SS(1)[0] = pfac*F[1];
#endif
#if LIBINT2_DEFINED(eri,LIBINT_T_SS_EREP_SS(2))
  erieval->LIBINT_T_SS_EREP_SS(2)[0] = pfac*F[2];
#endif
#if LIBINT2_DEFINED(eri,LIBINT_T_SS_EREP_SS(3))
  erieval->LIBINT_T_SS_EREP_SS(3)[0] = pfac*F[3];
#endif
#if LIBINT2_DEFINED(eri,LIBINT_T_SS_EREP_SS(4))
  erieval->LIBINT_T_SS_EREP_SS(4)[0] = pfac*F[4];
#endif
#if LIBINT2_DEFINED(eri,LIBINT_T_SS_EREP_SS(5))
  erieval->LIBINT_T_SS_EREP_SS(5)[0] = pfac*F[5];
#endif
#if LIBINT2_DEFINED(eri,LIBINT_T_SS_EREP_SS(6))
  erieval->LIBINT_T_SS_EREP_SS(6)[0] = pfac*F[6];
#endif
#if LIBINT2_DEFINED(eri,LIBINT_T_SS_EREP_SS(7))
  erieval->LIBINT_T_SS_EREP_SS(7)[0] = pfac*F[7];
#endif
#if LIBINT2_DEFINED(eri,LIBINT_T_SS_EREP_SS(8))
  erieval->LIBINT_T_SS_EREP_SS(8)[0] = pfac*F[8];
#endif
#if LIBINT2_DEFINED(eri,LIBINT_T_SS_EREP_SS(9))
  erieval->LIBINT_T_SS_EREP_SS(9)[0] = pfac*F[9];
#endif
#if LIBINT2_DEFINED(eri,LIBINT_T_SS_EREP_SS(10))
  erieval->LIBINT_T_SS_EREP_SS(10)[0] = pfac*F[10];
#endif
#if LIBINT2_DEFINED(eri,LIBINT_T_SS_EREP_SS(11))
  erieval->LIBINT_T_SS_EREP_SS(11)[0] = pfac*F[11];
#endif
#if LIBINT2_DEFINED(eri,LIBINT_T_SS_EREP_SS(12))
  erieval->LIBINT_T_SS_EREP_SS(12)[0] = pfac*F[12];
#endif
#if LIBINT2_DEFINED(eri,LIBINT_T_SS_EREP_SS(13))
  erieval->LIBINT_T_SS_EREP_SS(13)[0] = pfac*F[13];
#endif
#if LIBINT2_DEFINED(eri,LIBINT_T_SS_EREP_SS(14))
  erieval->LIBINT_T_SS_EREP_SS(14)[0] = pfac*F[14];
#endif
#if LIBINT2_DEFINED(eri,LIBINT_T_SS_EREP_SS(15))
  erieval->LIBINT_T_SS_EREP_SS(15)[0] = pfac*F[15];
#endif
#if LIBINT2_DEFINED(eri,LIBINT_T_SS_EREP_SS(16))
  erieval->LIBINT_T_SS_EREP_SS(16)[0] = pfac*F[16];
#endif
#if LIBINT2_DEFINED(eri,LIBINT_T_SS_EREP_SS(17))
  erieval->LIBINT_T_SS_EREP_SS(17)[0] = pfac*F[17];
#endif
#if LIBINT2_DEFINED(eri,LIBINT_T_SS_EREP_SS(18))
  erieval->LIBINT_T_SS_EREP_SS(18)[0] = pfac*F[18];
#endif
#if LIBINT2_DEFINED(eri,LIBINT_T_SS_EREP_SS(19))
  erieval->LIBINT_T_SS_EREP_SS(19)[0] = pfac*F[19];
#endif
#if LIBINT2_DEFINED(eri,LIBINT_T_SS_EREP_SS(20))
  erieval->LIBINT_T_SS_EREP_SS(20)[0] = pfac*F[20];
#endif
  st->erieval[0].contrdepth++;
  return evaluator;
}

static VALUE initialize_evaluator(VALUE evaluator){
  evaluator_struct* st;
  Data_Get_Struct(evaluator, evaluator_struct, st);
  st->centers.coords.Ax = NUM2DBL(rb_ivar_get(evaluator, rb_intern("@Ax")));
  st->centers.coords.Ay = NUM2DBL(rb_ivar_get(evaluator, rb_intern("@Ay")));
  st->centers.coords.Az = NUM2DBL(rb_ivar_get(evaluator, rb_intern("@Az")));
  st->centers.coords.Bx = NUM2DBL(rb_ivar_get(evaluator, rb_intern("@Bx")));
  st->centers.coords.By = NUM2DBL(rb_ivar_get(evaluator, rb_intern("@By")));
  st->centers.coords.Bz = NUM2DBL(rb_ivar_get(evaluator, rb_intern("@Bz")));
  st->centers.coords.Cx = NUM2DBL(rb_ivar_get(evaluator, rb_intern("@Cx")));
  st->centers.coords.Cy = NUM2DBL(rb_ivar_get(evaluator, rb_intern("@Cy")));
  st->centers.coords.Cz = NUM2DBL(rb_ivar_get(evaluator, rb_intern("@Cz")));
  st->centers.coords.Dx = NUM2DBL(rb_ivar_get(evaluator, rb_intern("@Dx")));
  st->centers.coords.Dy = NUM2DBL(rb_ivar_get(evaluator, rb_intern("@Dy")));
  st->centers.coords.Dz = NUM2DBL(rb_ivar_get(evaluator, rb_intern("@Dz")));
  st->erieval[0].contrdepth=0;
  rb_block_call(evaluator,
                rb_intern("each_primitive_shell_with_index"),
                0, NULL,
                RUBY_METHOD_FUNC(initialize_evaluator_primitive),
                evaluator);
  return evaluator;
}

static VALUE contrdepth(VALUE evaluator){
  evaluator_struct *st;
  Data_Get_Struct(evaluator, evaluator_struct, st);
  return rb_uint_new(st->erieval[0].contrdepth);
}

static VALUE evaluate(VALUE evaluator){
  evaluator_struct *st;
  Data_Get_Struct(evaluator, evaluator_struct, st);
  const unsigned int l0 = NUM2UINT(rb_ivar_get(evaluator, rb_intern("@l0"))),
                     l1 = NUM2UINT(rb_ivar_get(evaluator, rb_intern("@l1"))),
                     l2 = NUM2UINT(rb_ivar_get(evaluator, rb_intern("@l2"))),
                     l3 = NUM2UINT(rb_ivar_get(evaluator, rb_intern("@l3")));
  LIBINT2_PREFIXED_NAME(libint2_build_eri)[l0][l1][l2][l3](&st->erieval[0]);
  VALUE hash_class, result;
  hash_class = rb_const_get(rb_cObject, rb_intern("Hash"));
  rb_ivar_set(evaluator, rb_intern("@results"),
              result = rb_obj_alloc(hash_class));
  int ax, ay, az, bx, by, bz, cx, cy, cz, dx, dy, dz, i=0;
  FOR_CART(ax, ay, az, l0) FOR_CART(bx, by, bz, l1) FOR_CART(cx, cy, cz, l2) FOR_CART(dx, dy, dz, l3){
    rb_apply(result, rb_intern("store"),
        rb_ary_new3(2,
          rb_ary_new3(4, rb_ary_new3(3, INT2NUM(ax), INT2NUM(ay), INT2NUM(az)),
            rb_ary_new3(3, INT2NUM(bx), INT2NUM(by), INT2NUM(bz)),
            rb_ary_new3(3, INT2NUM(cx), INT2NUM(cy), INT2NUM(cz)),
            rb_ary_new3(3, INT2NUM(dx), INT2NUM(dy), INT2NUM(dz))),
          DBL2NUM(st->erieval[0].targets[0][i++])));
  } END_FOR_CART END_FOR_CART END_FOR_CART END_FOR_CART
  return evaluator;
}

static VALUE reorder_shells(VALUE,
                            VALUE s0, VALUE vl0,
                            VALUE s1, VALUE vl1,
                            VALUE s2, VALUE vl2,
                            VALUE s3, VALUE vl3){
  unsigned int l0 = NUM2UINT(vl0),
               l1 = NUM2UINT(vl1),
               l2 = NUM2UINT(vl2),
               l3 = NUM2UINT(vl3);
#if LIBINT_SHELL_SET == LIBINT_SHELL_SET_STANDARD
  if(l0 >= l1 && l2 >= l3 && l0 + l1 <= l2 + l3)
#elif LIBINT_SHELL_SET == LIBINT_SHELL_SET_ORCA
  if(l0 <= l1 && l2 <= l3 && l0 < l2 || (l0 == l2 && l1 < l3))
#endif
  return rb_ary_new3(8, s0, vl0,
                        s1, vl1, 
                        s2, vl2, 
                        s3, vl3 );
  unsigned int i[4] = {0, 1, 2, 3};
  const VALUE vl[4] = {vl0, vl1, vl2, vl3};
  const VALUE s[4] = {s0, s1, s2, s3};
#if LIBINT_SHELL_SET == LIBINT_SHELL_SET_STANDARD
  if(l0 < l1) std::swap(i[0], i[1]);
  if(l2 < l3) std::swap(i[2], i[3]);
  if(l0+l1 > l2+l3){
    std::swap(i[0], i[2]);
    std::swap(i[1], i[3]);
  }
#elif LIBINT_SHELL_SET == LIBINT_SHELL_SET_ORCA
  if(l0 > l1) std::swap(i[0], i[1]);
  if(l2 > l3) std::swap(i[2], i[3]);
  if(l0 > l2 || l1 > l3){
    std::swap(i[0], i[2]);
    std::swap(i[1], i[3]);
  }
#endif
  return rb_ary_new3(8, s[i[0]], vl[i[0]],
                        s[i[1]], vl[i[1]], 
                        s[i[2]], vl[i[2]], 
                        s[i[3]], vl[i[3]] );
}

extern "C"
void ruphy_libint2_define_evaluator(VALUE libint2_module){
  evaluator_class = rb_define_class_under(libint2_module, "Evaluator", rb_cObject);
  rb_define_singleton_method(evaluator_class, "new", RUBY_METHOD_FUNC(new_method), -2);
  rb_define_singleton_method(evaluator_class, "reorder_shells", RUBY_METHOD_FUNC(reorder_shells), 8);

  rb_define_method(evaluator_class, "packed_center_coordinates", RUBY_METHOD_FUNC(packed_center_coordinates), 0);
  rb_define_method(evaluator_class, "contrdepth", RUBY_METHOD_FUNC(contrdepth), 0);
  rb_define_method(evaluator_class, "initialize_evaluator", RUBY_METHOD_FUNC(initialize_evaluator), 0);
  rb_define_method(evaluator_class, "evaluate", RUBY_METHOD_FUNC(evaluate), 0);
}

#endif // HAVE_LIBINT2_H
/* vim: set et sw=2 : */
