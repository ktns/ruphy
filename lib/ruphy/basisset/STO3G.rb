require 'ruphy/orbital/gaussian.rb'

module RuPHY
	module BasisSet
		class STO3G < Base
			def initialize element, center
				@bases = []
				case element
				when 'H'
					@bases << Orbital::Gaussian::Contracted.new(
						[0.15432897,0.53532814,0.44463454],
						[3.42525091,0.62391373,0.16885540],
						[0,0,0],
						center)
				end
			end

			def each &block
				@bases.each &block
			end
		end
	end
end
