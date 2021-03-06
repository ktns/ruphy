require 'matrix'

module RuPHY
	module Theory
		module RHF
			class Matrix < ::Matrix
				def self.[]
					raise NoMethodError
				end
				public_class_method :new

				def initialize rows
					rows.kind_of?(Array) or raise TypeError, 'Expected Array, but %s' % rows.class
					rows.first.kind_of?(Array) or raise TypeError, 'Expected Array, but %s' % rows.first.class
					begin
						init_rows rows, true
					rescue NoMethodError
						super rows
					end
				end
			end

			class CoefficientMatrix < Matrix

			end

			class FockianMatrix < Matrix

			end

			class OverlapMatrix < Matrix
				def initialize bases
					super(bases.map do |bi|
						bases.map do |bj|
							bi * bj
						end
					end)
				end
			end

			class OneElectronMatrix < Matrix

			end

			class TwoElectronMatrix < Matrix

			end

			class Solver
				def initialize geometry, basisset
					raise NotImplementedError
				end
			end
		end
	end
end
