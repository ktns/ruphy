module RuPHY
	module Math
		include ::Math

		def boys(r,m)
			case m
			when 0
				rr = sqrt(r)
				return sqrt(PI) * erf(rr) / 2 / rr
			when Integer
				raise ArgumentError, 'Negative m specified!' unless m >= 0
				return (boys(r,m-1) * (2*m-1) - exp(-r)) / 2 / r
			else
				raise ArgumentError, 'Unsupported value for m(=%p)!', m
			end
		end
	end
end
