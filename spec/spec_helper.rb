$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
begin
	require 'simplecov'
	SimpleCov.start do
		add_filter '/spec/'
	end
rescue LoadError
end if ENV['SIMPLECOV']

require 'rspec'
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

def random_coordinate
	return (1-a=rand())/a, rand() * Math::PI/2, rand() * Math::PI
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
					self.class.class_eval do
						define_method(:subject) do
							@_subject ||= lambda { instance_eval(&self.class.subject) }
						end
					end
					instance_eval(&block)
				end
			end
		end
	end
end

RSpec.configure do |c|
	c.extend RSpec::CallingIt::ExampleGroupMethods
end
