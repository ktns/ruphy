module RuPHY
	module GSL
		module SPWF
			class Combination
				include SPWF

				def initialize *args
					[nil,false].each do |n|
						raise ArgumentError, "#{SPWF} expected, but#{n}!" if args.include?(n)
					end
					err = args.find{|arg|not arg.kind_of?(SPWF)}
					raise TypeError, "#{SPWF} expected, but #{err.class}!" if err

					setup_params *args
				end
			end
		end
	end
end
