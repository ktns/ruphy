require 'mkmf'

pkgconfig_incflags,_ = pkg_config('libint2')
if pkgconfig_incflags
  $INCFLAGS+= ' ' + pkgconfig_incflags # Required for CXXFLAGS
end

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

_, endproc_def =
[ %w'(void*) -DRUPHY_ENDPROC_VOID',
  %w'(void(*)(VALUE)) -DRUPHY_ENDPROC_FUNC' ].find do |type, _|
    try_compile(<<EOS)
#include <ruby.h>
int main(void){
  rb_set_end_proc(#{type}0, Qnil);
}
EOS
  end
$defs << endproc_def unless endproc_def.nil?

$CFLAGS.sub!(COMPILER_LANG_FLAG_CXX, '')

have_func('libint2_init_eri')

create_header
create_makefile('ruphy_libint2')
