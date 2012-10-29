require 'ruphy/ao/gaussian'

module RuPHY
	module BasisSet
		module LCAO
			module Gaussian
				class Shell
					def initialize azimuthal_quantum_numbers, coeffs, zetas, center
						raise NotImplementedError
					end
				end
			end
		end
	end
end
