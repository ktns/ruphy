module RuPHY::GSL
	module SPOP
		class Translation
			include RuPHY::Digestable
			include SPOP

			def initialize dx, dy, dz
				@dx, @dy, @dz = dx, dy, dz
				setup_params dx, dy, dz
			end
			attr_reader :dx, :dy, :dz

			def inverse
				self.class.new -@dx, -@dy, -@dz 
			end

			def digest_args
				[self.class, @dx, @dy, @dz]
			end
		end
	end
end
