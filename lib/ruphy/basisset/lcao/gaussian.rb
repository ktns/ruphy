require 'ruphy/ao/gaussian'

module RuPHY
	module BasisSet
		module LCAO
			class Gaussian < BasisSet::Base
				class InvalidElementError < ArgumentError
					def initialize e
						super 'Invalid Element `%p\'!' % e
					end
				end

				class ElementNotFoundError < ArgumentError
					def initialize e
						super 'Element `%s\' is not in this basis set!' % e
					end
				end

				class Hash < ::Hash
					def initialize
						super do |e|
							if RuPHY::Element === e or RuPHY::Elements[e]
								raise ElementNotFoundError.new(e)
							else
								raise InvalidElementError.new(e)
							end
						end
					end

					def []= e,b
						begin
							unless e = RuPHY::Elements[e]
								raise InvalidElementError.new(e)
							end
						rescue
							raise InvalidElementError.new(e)
						end
						super
					end
				end

				def initialize arg
					@basisset = arg.each_with_object(Hash.new) do |(e,b),s|
						s[e] = b
					end.freeze
				end

				def elements
					@basisset.keys
				end

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
						@azimuthal_quantum_numbers = [azimuthal_quantum_numbers].flatten
						l = @azimuthal_quantum_numbers.find do |l|
							not l>=0 && Integer === l
						end
						raise ArgumentError, 'Invalid azimuthal quantum number!(%p)' % l if l
						raise ArgumentError, 'Number of coefficients(%d) and zetas(%d) don\'t match!' %
							[coeffs.count, zetas.count] unless coeffs.count == zetas.count
						@coeffs, @zetas, @center =  coeffs, zetas, center
					end

					def cart_angular_momenta
						@azimuthal_quantum_numbers.map do |l|
							self.class.cart_angular_momenta(l)
						end.flatten(1)
					end

					def aos
						cart_angular_momenta.map do |momenta|
							RuPHY::AO::Gaussian::Contracted.new(@coeffs, @zetas, momenta, @center)
						end
					end
				end
			end
		end
	end
end
