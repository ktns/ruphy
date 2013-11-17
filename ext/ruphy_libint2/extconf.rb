require 'mkmf'

dir_config('libint2')

have_library('stdc++')

have_library('int2', 'libint2_init_eri')
have_header('libint2.h')
have_func('libint2_init_eri')

create_header
create_makefile('ruphy_libint2')
