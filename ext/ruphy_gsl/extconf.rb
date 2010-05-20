require 'mkmf'

dir_config("ruphy_gsl")

$CFLAGS = $CFLAGS.split(/\s+/)

if enable_config('deriv-test')
	$CFLAGS << '-DRUPHY_DERIV_TEST'
end

$CFLAGS << '-Wall'

$CFLAGS = $CFLAGS.join(' ')

def gsl_check
	find_library('gsl', 'gsl_sf_legendre_Plm') or
	find_library('gslcblas', 'cblas_ctrmv') and
	find_library('gsl', 'gsl_sf_legendre_Plm')
end

unless gsl_check
	raise 'Extention build dependency is not met! Please install libgsl!'
end

create_makefile("ruphy_gsl")
