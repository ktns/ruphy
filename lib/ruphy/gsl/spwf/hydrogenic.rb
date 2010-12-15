module RuPHY
	module GSL
		module SPWF
			# Represent wave functions of hydrogenic atoms.
			class Hydrogenic
				include Digestable
				include SPWF
				#Raised when invalid quantum numbers was given.
				class InvalidQuantumNumbersError < Exception
					#Check given quantum numbers, and raise this exception if invalid.
					def self.check n,l,m
						unless [n,l,m].all?{|v| v.class <= Integer}
							raise TypeError, 'Integers expected for quantum number,' +
								"but #{[n,l,m].collect{|v|v.class}.join(',')}"
						end
						raise new(n, l, m) unless n > 0 && l >= 0 && l < n && m.abs <= l
					end

					def initialize n,l,m
						super "(n,l,m) = (#{[n,l,m].join(',')}) is invalid quantum number set!"
					end
				end

				#Raised when invalid atomic number was given.
				class InvalidAtomicNumberError < Exception
					#Check given atomic number, and raise this exception if invalid.
					def self.check z
						raise TypeError, 'Integer expected for atomic number,' +
							"but #{z.class}" unless z.class <= Integer
						raise new(z) unless z > 0
					end

					def initialize z
						super "`#{z} is invalid atomic number!"
					end
				end

				#Initialize an instance for given atomic number and quantum number set.
				def initialize n, l, m, z = 1
					InvalidQuantumNumbersError.check n, l, m
					InvalidAtomicNumberError.check z
					@n,@l,@m,@Z = n,l,m,z
					setup_params n,l,m,z
				end

				attr_reader :n, :l, :m, :Z

				def to_s
					"(#{@n}, #{@l}, #{@m})Z=#{@Z}"
				end

				def inspect
					"<SPWF::Hydrogenic: n=#{@n} l=#{@l}, m=#{@m}, Z=#{@Z}>"
				end

				def to_a
					[self.class, @n, @l, @m, @Z]
				end
				protected :to_a

				def digest_args
					to_a
				end

				def eql? other
					self.class == other.class and
					to_a.eql? other.to_a
				end

				def == other
					self.class == other.class and
					to_a == other.to_a
				end
			end
		end
	end
end
