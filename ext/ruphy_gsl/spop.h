#ifndef _SPOP_H_
#define _SPOP_H_

void init_SPOP(void);

#define DERIV_DX (1e-8)

gsl_complex spop_r_deriv    ( double r, double theta, double phy, void *op_params, spwf_func spwf, void *wf_params );
gsl_complex spop_theta_deriv( double r, double theta, double phy, void *op_params, spwf_func spwf, void *wf_params );
gsl_complex spop_phy_deriv  ( double r, double theta, double phy, void *op_params, spwf_func spwf, void *wf_params );

gsl_complex spop_laplacian  ( double r, double theta, double phy, void *op_params, spwf_func spwf, void *wf_params );

void get_func_param_from_spop(VALUE spop, spop_func **func, void **params);

#ifdef RUPHY_DERIV_TEST
VALUE test_deriv_r(VALUE self, VALUE index, VALUE arg_r);
VALUE test_deriv_theta( VALUE self, VALUE index,   VALUE arg_theta);
VALUE test_deriv_phy  ( VALUE self, VALUE index,   VALUE arg_phy);
#endif //RUPHY_DERIV_TEST

#endif //_SPOP_H_
