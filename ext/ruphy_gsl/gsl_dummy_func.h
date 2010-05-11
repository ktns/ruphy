#ifndef _RuPHY_GSL_DUMMY_FUNC_H_
#define _RuPHY_GSL_DUMMY_FUNC_H_

typedef struct {
	spwf_func  func;
	double     r;
	double     theta;
	double     phy;
	void      *params;
	double    *variable;
} gsl_dummy_func_params;

double gsl_dummy_func_real(double x, void *arg_params);
double gsl_dummy_func_imag(double x, void *arg_params);

#endif // _RuPHY_GSL_DUMMY_FUNC_H_
