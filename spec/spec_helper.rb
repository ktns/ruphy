begin
	require 'rspec'
rescue LoadError
	require 'rubygems' unless ENV['NO_RUBYGEMS']
	gem 'rspec'
	require 'rspec'
end

def random_complex
	Complex.new(rand(), rand())
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

class BeEquivalent
	def initialize expected, &block
		if expected
			raise TypeError, "expected #{RuPHY::GSL::SPWF}, but #{expected}!" unless expected.kind_of?(RuPHY::GSL::SPWF)
		else
			raise ArgumentError, 'No expectation specified!' unless block
		end
		@expected, @block = expected, block
	end

	def matches? target
		@target = target
		@vals = Array.new(10) do
			begin
				coord = random_coordinate
				[coord, target.eval(*coord),
					if @block
						case @block.arity
						when 1
							@block.call(@expected.eval(*coord))
						when 3
							@block.call(*coord)
						end
					else
						@expected.eval(*coord)
					end
				]
			rescue RuPHY::GSL::GSLError
				retry if $!.errno == RuPHY::GSL::GSLError::Errno::GSL_EUNDRFLW
			end
		end
		@vals.all?{|coord, vt, ve| (vt - ve).abs < 1e-8}
	end

	def failure_message
		coord, vt, ve = *(@vals.find{|coord, vt, ve| vt != ve})
		"expected #{@target}(#{'r=%e, theta=%e, phy=%e'%coord}) to return #{'%s'%ve}, but returned #{'%s'%vt}!"
	end

	def negative_failure_message
		"expected #{@vals.collect do|coord, vt, ve| 
			"#{@target}(#{'r=%e, theta=%e, phy=%e'%coord}) not to return #{'%s'%ve}"
		end.join(" or,\n\t")}, but returned unexpected value!"
	end
end

module RuPHY::GSL::SPWF
	def should_be_equivalent expected=nil, &block
		self.should BeEquivalent.new(expected, &block)
	end
end
