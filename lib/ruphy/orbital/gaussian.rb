module RuPHY
	class Orbital
		class Gaussian < Orbital
			def initialize *args
				raise NotImplementedError
			end

			class Primitive < Orbital
				def initialize zeta, momenta, center
					@zeta, @momenta, @center = [zeta.to_f,
						(momenta.to_ary rescue momenta.to_a),
						Vector[*center]].map(&:freeze)
					raise ArgumentError, 'Invalid value for a zeta(%p)!' % zeta unless @zeta > 0
					raise ArgumentError, 'Invalid size of momenta(%d)!' % @momenta.size unless @momenta.size == 3
					@momenta.each do |m|
						raise TypeError, 'Invalid type for a momentum(%p)!' % m.class unless m.kind_of?(Integer)
						raise ArgumentError, 'Invalid value for a momentum(%d)!' % m unless m>=0
					end
					raise ArgumentError, 'Invalid dimension of center coordinates(%d)!' % center.size unless center.size == 3
				end

				attr_reader :zeta, :momenta, :center

				def angular_momentum
					@momenta.reduce(:+)
				end

				def normalization_factor
					overlap(self)**(-0.5)
				end

				def overlap other
					raise NotImplementedError
				end
			end

			class Contracted < Orbital
				def initialize coeffs, zetas, momenta, center
					@primitives=[coeffs,zetas].transpose.map do |c,zeta|
						[c, Primitive.new(zeta,momenta,center)]
					end
				end
			end
		end
	end
end
