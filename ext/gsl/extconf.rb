require 'mkmf'

dir_config("gsl")

def gsl_check
	find_library('gsl', 'gsl_sf_legendre_Plm') or
	find_library('gslcblas', 'cblas_ctrmv') and
	find_library('gsl', 'gsl_sf_legendre_Plm')
end

unless gsl_check
	raise 'Extention build dependency is not met! Please install libgsl!'
end

create_makefile("gsl")
