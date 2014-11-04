require 'bundler'

Bundler.require(:test)

require 'ruphy'
require 'tempfile'


# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|

end

def random_positive
  - Math::log(rand())
end

def random_complex
  rand() + Complex::I * rand()
end

def random_spwf_hydrogenic_subset count
   unless count.kind_of?(Integer) && count > 0
     raise ArgumentError, "specify positive Integer instead of `#{count}'!"
   end

  phies = []
  until phies.size >= count
    phies << random_spwf_hydrogenic(phies.map(&:Z).first)
    phies.uniq!
  end
  return phies
end

def random_vector
  return Vector[*3.times.map{rand()}]
end

def random_element range = 1..1000
  elements = RuPHY::Elements
  if elements.empty? 
    elements = RuPHY::Elements.class.new.extend(RuPHY::ElementData::PreDefined)
    elements.load_all
  end
  begin 
    random_element = elements.values.sample
  end until range === random_element.z
  return random_element
end

def random_angular_momenta(l)
  [Vector[0,0,1], Vector[0,1,0], Vector[0,0,1]].repeated_combination(l).to_a.sample.reduce(Vector[0,0,0], &:+).to_a
end

begin
  TestMol = RuPHY::Geometry::Molecule.new(<<EOF, 'xyz')
2
Hydrogen
H 0 0 0
H 0 0 0.74
EOF
rescue Exception
  TestMol = nil
end

RSpec::Matchers.define :include_a do |exp|
  match do |act|
    act.any?{|a| exp === a}
  end

  failure_message do |act|
    'expected %p to include a instance of %p' % [act,exp]
  end

  failure_message_when_negated do |act|
    'expected %p not to include a instance of %p' % [act,exp]
  end
end

module RSpec
  module CallingIt
    module ExampleGroupMethods
      def calling_it(&block)
        example do
          class << d = self.dup
            alias subject_original subject
            def subject
              lambda { subject_original }
            end
          end
          d.instance_eval(&block)
        end
      end

      alias creating_it calling_it
    end
  end
end

module Matchers
  include RSpec::Matchers
  alias return_a be_a
end

RSpec.configure do |c|
  c.extend RSpec::CallingIt::ExampleGroupMethods
  c.include Matchers
end

module TestCenter
  def center
    Vector[0,0,0]
  end
end

module TestShell
  attr_reader :sets_of_coeffs, :zetas
end

def dummy_atom x = 0, y = 0, z = 0, atomic_num = 1
  obatom = double(:obatom)
  allow(obatom).to receive(:x).and_return(x); allow(obatom).to receive(:get_x).and_return(x)
  allow(obatom).to receive(:y).and_return(y); allow(obatom).to receive(:get_y).and_return(y)
  allow(obatom).to receive(:z).and_return(z); allow(obatom).to receive(:get_z).and_return(z)
  allow(obatom).to receive(:get_atomic_num).and_return(atomic_num)
  RuPHY::Geometry::Atom.new obatom
end

def mock_primitive name=:primitive, opts={}
  primitive = double(name)
  allow(primitive).to receive(:zeta).and_return(opts[:zeta] || rand())
  return primitive
end

def mock_vector value, name=:vector, xyz=nil
  vector = double(name)
  allow(vector).to receive(:[]).with(xyz).and_return(value)
  return vector
end

# Ruby < 2.1 workaround
unless [].respond_to?(:to_h)
  class Array
    def to_h
      Hash[*self.flatten(1)]
    end
  end
end
