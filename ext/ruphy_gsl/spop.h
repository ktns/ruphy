#ifndef _SPOP_H_
#define _SPOP_H_

#define DERIV_DX (1e-8)

gsl_complex r_deriv    ( double r, double theta, double phy, void *op_params, spwf_func spwf, void *wf_params );
gsl_complex theta_deriv( double r, double theta, double phy, void *op_params, spwf_func spwf, void *wf_params );
gsl_complex phy_deriv  ( double r, double theta, double phy, void *op_params, spwf_func spwf, void *wf_params );

#endif //_SPOP_H_
