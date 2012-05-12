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

				def overlap o
					z=@zeta+o.zeta
					c=(@center*@zeta+o.center*o.zeta)*z**-1.0
					[@center-c,o.center-c,@momenta,o.momenta].map(&:to_a).transpose.map do |a,b,m,n|
						integral(a,b,m,n,z)
					end.reduce(:*) * exp(@zeta*o.zeta/z*(@center-o.center).r**2)
				end

				include Math
				private
				# calculate one dimensional integral over entire space of
				# (x-a)^m(x-b)^n exp(-z*x^2)
				def integral a,b,m,n,z
					case m
					when 0
						case n
						when 0
							sqrt(PI/z)
						when 1
							-b*sqrt(PI/z)
						else
							(b**2+(n-1)/2.0/z) * integral(a,b,m,n-2,z) -
								2*b * integral(a,b,m,n-1,z)
						end
					when 1
						case n
						when 0
							-a*sqrt(PI/z)
						when 1
							(a*b+0.5/z)*sqrt(PI/z)
						else
							(b**2+(n-1)/2.0/z) * integral(a,b,m,n-2,z) -
								2*b * integral(a,b,m,n-1,z)
						end
					else
							(a**2+(m-1)/2.0/z) * integral(a,b,m-2,n,z) -
								2*a * integral(a,b,m-1,n,z)
					end
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
