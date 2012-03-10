require 'mkmf'

dir_config("ruphy_gsl")

if enable_config('deriv-test')
	$defs << '-DRUPHY_DERIV_TEST'
end

if enable_config('gsl-error-test')
	$defs << '-DRUPHY_GSL_ERROR_TEST'
end

$CFLAGS = $CFLAGS.split(/\s+/)

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

create_header
create_makefile("ruphy_gsl")
