begin
	require 'spec'
rescue LoadError
	require 'rubygems' unless ENV['NO_RUBYGEMS']
	gem 'rspec'
	require 'spec'
end

def mock_spop name=:spop
	spop = mock(name)
	spop.extend RuPHY::GSL::SPOP
	return spop
end

def mock_spwf name = :spwf
	spwf = mock(name)
	spwf.extend RuPHY::GSL::SPWF
	return spwf
end

def random_spwf_hydrogenic z = nil
	z = rand(120) + 1 unless z
	n = rand(10) + 1
	l = rand(n)
	m = rand(2*l + 1) - l
	RuPHY::GSL::SPWF::Hydrogenic.new(n,l,m,z)
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

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'ruphy'
