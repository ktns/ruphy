#ifndef _RuPHY_SPWF_H_
#define _RuPHY_SPWF_H_

extern VALUE rb_mSPWF;

void init_SPWF(void);
void init_SPWF_Hydrogenic(void);
void init_SPWF_Operated(void);
void init_SPWF_Combination(void);

void get_func_param(VALUE spwf, spwf_func **func, void** params);

#endif // _RuPHY_SPWF_H_
