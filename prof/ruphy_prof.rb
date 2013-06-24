$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)+'/../lib'))
require 'ruphy'
require 'ruphy/basisset/STO3G'

RubyVM::InstructionSequence.compile_option = {
  :tailcall_optimization => true,
  :trace_instruction => false
}
