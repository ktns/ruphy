module RuPHY::GSL
	# Represents an operator which acts on single particle wave functions.
	module SPOP
		def * other
			case other
			when SPWF
				return SPWF::Operated.new self, other
			else
				raise NotImplementedError, "#{self.class} * #{other.class} is not implemented!"
			end
		end
	end
end

require 'ruphy/gsl/spop/combination'
require 'ruphy/gsl/spop/hamiltonian'
require 'ruphy/gsl/spop/multiplier'
