require 'matrix'

module RuPHY
	module Theory
		module RHF
			class Matrix < ::Matrix
				def self.[]
					raise NoMethodError
				end
				public_class_method :new
			end

			class CoefficientMatrix < Matrix

			end

			class FockianMatrix < Matrix

			end

			class OverlapMatrix < Matrix

			end

			class OneElectronMatrix < Matrix

			end

			class TwoElectronMatrix < Matrix

			end

			class Solver

			end
		end
	end
end
