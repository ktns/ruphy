#ifndef _RuPHY_GSL_SPWF_INTEGRATE_H_
#define _RuPHY_GSL_SPWF_INTEGRATE_H_

gsl_complex integrate_spwf(spwf_func func, void *arg_params);

void init_SPWF_Integrate(VALUE rb_mSPWF);

#endif // _RuPHY_GSL_SPWF_INTEGRATE_H_
