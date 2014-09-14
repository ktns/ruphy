require 'mkmf'

incdir, libdir = dir_config('libint2')

HEADER_SEARCH_PATH = %W<#{incdir} #{incdir}/libint2 /usr/include/libint2 /usr/local/include/libint2>
HEADER_SEARCH_PATH.select!{|d| File.directory?(d)}

have_library('stdc++')

have_library('int2', 'libint2_init_eri')
COMPILER_LANG_FLAG_CXX=' -x c++'
$CFLAGS+=COMPILER_LANG_FLAG_CXX
have_header('libint2.h') or
  find_header('libint2_params.h', *HEADER_SEARCH_PATH) and have_header('libint2_params.h') or
  find_header('libint2.h', *HEADER_SEARCH_PATH) and have_header('libint2.h') or
  raise "Error: cannot find libint2.h. Please specify --with-libint2-dir option."
$CFLAGS.sub!(COMPILER_LANG_FLAG_CXX, '')
have_func('libint2_init_eri')

create_header
create_makefile('ruphy_libint2')
