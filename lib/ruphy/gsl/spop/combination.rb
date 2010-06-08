module RuPHY::GSL
	module SPOP
		class Combination
			include SPOP

			def initialize *spops
				@spops = spops.sort_by(&:hash).freeze
				setup_params *@spops
			end
			attr_reader :spops

			def hash
				[self.class, @spops].hash
			end

			def eql? other
				self.class.eql? other.class and
				@spops.eql? other.spops
			end

			def == other
				self.class == other.class and
				@spops == other.spops
			end
		end
	end
end
