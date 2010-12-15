module RuPHY
	module GSL
		module SPWF
			class Combination
				include Digestable
				include SPWF

				def initialize *args
					[nil,false].each do |n|
						raise ArgumentError, "#{SPWF} expected, but#{n}!" if args.include?(n)
					end
					err = args.find{|arg|not arg.kind_of?(SPWF)}
					raise TypeError, "#{SPWF} expected, but #{err.class}!" if err

					@spwfs = args.sort_by(&:hash).freeze
					setup_params *@spwfs
				end
				attr_reader :spwfs

				def digest_args
					[self.class, @spwfs]
				end

				def eql? other
					self.class.eql? other.class and
					@spwfs.eql? other.spwfs
				end

				def == other
					self.class == other.class and
					@spwfs == other.spwfs
				end
			end
		end
	end
end
