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
