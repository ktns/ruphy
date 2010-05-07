#ifndef _SPOP_H_
#define _SPOP_H_

void init_SPOP(void);

#define DERIV_DX (1e-8)

gsl_complex spop_r_deriv    ( double r, double theta, double phy, void *op_params, spwf_func spwf, void *wf_params );
gsl_complex spop_theta_deriv( double r, double theta, double phy, void *op_params, spwf_func spwf, void *wf_params );
gsl_complex spop_phy_deriv  ( double r, double theta, double phy, void *op_params, spwf_func spwf, void *wf_params );

gsl_complex spop_laplacian  ( double r, double theta, double phy, void *op_params, spwf_func spwf, void *wf_params );

VALUE test_deriv_r(VALUE self, VALUE arg_r);

#endif //_SPOP_H_
