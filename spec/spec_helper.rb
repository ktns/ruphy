require 'bundler'

Bundler.require(:test)

require 'ruphy'
require 'tempfile'


# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|

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

def random_element
  elements = RuPHY::Elements
  if elements.empty? 
    elements = RuPHY::Elements.class.new.extend(RuPHY::ElementData::PreDefined)
    elements.load_all
  end
  elements.values.sample
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

  failure_message_for_should do |act|
    'expected %p to include a instance of %p' % [act,exp]
  end

  failure_message_for_should_not do |act|
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
  attr_reader :coeffs, :zetas
end

def dummy_atom x = 0, y = 0, z = 0, atomic_num = 1
  obatom = mock(:obatom)
  obatom.stub(:x).and_return(x); obatom.stub(:get_x).and_return(x)
  obatom.stub(:y).and_return(y); obatom.stub(:get_y).and_return(y)
  obatom.stub(:z).and_return(z); obatom.stub(:get_z).and_return(z)
  obatom.stub(:get_atomic_num).and_return(atomic_num)
  RuPHY::Geometry::Atom.new obatom
end

def mock_primitive name=:primitive, opts={}
  primitive = mock(name)
  primitive.stub(:zeta).and_return(opts[:zeta] || rand())
  return primitive
end

def mock_vector value, name=:vector, xyz=nil
  vector = mock(name)
  vector.stub(:[]).with(xyz).and_return(value)
  return vector
end
