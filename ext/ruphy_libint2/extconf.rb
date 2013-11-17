require 'mkmf'

dir_config('libint2')

have_library('stdc++')

find_library('int2', 'libint2_init_eri')
find_header('libint2.h')

create_makefile('ruphy_libint2')
