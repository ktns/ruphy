require 'ruphy/ao/gaussian'

module RuPHY
	module BasisSet
		module LCAO
			module Gaussian
				class Shell
					CartAngularMomentumBasis =
						[Vector[1,0,0], Vector[0,1,0], Vector[0,0,1]].each(&:freeze).freeze

					@@cart_angular_momenta = {}
					def self.cart_angular_momenta l
						@@cart_angular_momenta[l]||=
							CartAngularMomentumBasis.repeated_combination(l).map do |b|
								b.inject(Vector[0,0,0],&:+)
							end.each(&:freeze).freeze
					end

					def initialize azimuthal_quantum_numbers, coeffs, zetas, center
						raise NotImplementedError
					end
				end
			end
		end
	end
end
