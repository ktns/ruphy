module RuPHY
	class Orbital
		class Gaussian < Orbital
			def initialize *args
				raise NotImplementedError
			end

			class Primitive < Orbital
				include RuPHY::Math
				def initialize zeta, momenta, center, derivative_order = [0,0,0]
					@zeta, @momenta, @center, @derivative_order = [zeta.to_f,
						(momenta.to_ary rescue momenta.to_a),
						Vector[*center],Vector[*derivative_order]].map(&:freeze)
					raise ArgumentError, 'Invalid value for a zeta(%p)!' % zeta unless @zeta > 0
					raise ArgumentError, 'Invalid size of momenta(%d)!' % @momenta.size unless @momenta.size == 3
					@momenta.each do |m|
						raise TypeError, 'Invalid type for a momentum(%p)!' % m.class unless m.kind_of?(Integer)
						raise ArgumentError, 'Invalid value for a momentum(%d)!' % m unless m>=0
					end
					raise ArgumentError, 'Invalid dimension of center coordinates(%d)!' % center.size unless center.size == 3
				end

				attr_reader :zeta, :momenta, :center, :derivative_order

				def deriv_x n = 1
					self.class.new(@zeta,@momenta,@center,@derivative_order + Vector[1,0,0] * n)
				end

				def deriv_y n = 1
					self.class.new(@zeta,@momenta,@center,@derivative_order + Vector[0,1,0] * n)
				end

				def deriv_z n = 1
					self.class.new(@zeta,@momenta,@center,@derivative_order + Vector[0,0,1] * n)
				end

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
						cart_gauss_integral(a,b,m,n,z)
					end.reduce(:*) * exp(-@zeta*o.zeta/z*(@center-o.center).r**2)
				end

				def kinetic o
					z = @zeta+o.zeta
					c = (@center*@zeta + o.center*o.zeta)*z**-1.0
					3.times.map do |i|
						[@center-c,o.center-c,@momenta,o.momenta].map(&:to_a).transpose.each_with_index.map do |(a,b,m,n),j|
							if i==j
								4*o.zeta**2*cart_gauss_integral(a,b,m,n+2,z) - 
									2*o.zeta*(2*n+1)*cart_gauss_integral(a,b,m,n,z) +
									(n>1 ? n*(n-1)*cart_gauss_integral(a,b,m,n-2,z) : 0)
							else
								cart_gauss_integral(a,b,m,n,z)
							end
						end.reduce(:*)
					end.reduce(:+) * exp(-@zeta*o.zeta/z*(@center-o.center).r**2)/-2
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
