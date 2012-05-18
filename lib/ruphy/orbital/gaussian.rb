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
					e=m+n
					if e > 0
						d=e+1
						coefs=Vector[1,*[0]*e]
						shifter=Matrix[*[[0]*d]+(Matrix.identity(e).to_a+[[0]*e]).transpose]
						coefs=(m>0 ? (Matrix.identity(d)*-a+shifter)**m : Matrix.identity(d))*coefs
						coefs=(n>0 ? (Matrix.identity(d)*-b+shifter)**n : Matrix.identity(d))*coefs
						coefs.each_with_index.inject(0) do |s,(a,n)|
							if n % 2 == 0
								s + a*(n-1).downto(1).reduce(1,:*).downto(1).reduce(1,:*)/(2*z)**(n/2)
							else
								s
							end
						end
					else
						1
					end*sqrt(PI/z)
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
