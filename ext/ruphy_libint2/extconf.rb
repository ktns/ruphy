require 'mkmf'

incdir, libdir = dir_config('libint2')

HEADER_SEARCH_PATH = %w</usr/include/libint2 /usr/local/include/libint2>
if File.directory?(dir = File.join(incdir, 'libint2') rescue '')
  HEADER_SEARCH_PATH << dir
end

have_library('stdc++')

have_library('int2', 'libint2_init_eri')
have_header('libint2.h') or
  find_header('libint2.h', *HEADER_SEARCH_PATH) and have_header('libint2.h') or
  raise "Error: cannot find libint2.h. Please specify --with-libint2-dir option."
have_func('libint2_init_eri')

create_header
create_makefile('ruphy_libint2')
