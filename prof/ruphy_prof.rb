$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)+'/../lib'))

require 'bundler'
Bundler.require(:default, :profile)

require 'ruphy'
require 'ruphy/basisset/STO3G'

if defined? RubyVM::InstructionSequence
  RubyVM::InstructionSequence.compile_option = {
    :tailcall_optimization => true,
    :trace_instruction => false
  }
end

module RuPHY::Profile
  def profile output=ARGV.shift
    if defined? RubyProf
      RubyProf.start
      yield
      result = RubyProf.stop
      File.open(output, 'w') do |f|
        RubyProf::CallTreePrinter.new(result).print(f)
      end
    elsif defined? Rubinius
      abort 'TODO: rubinius profiler support'
    else
      abort "No known profiler available!"
    end
  end

  extend self
end
