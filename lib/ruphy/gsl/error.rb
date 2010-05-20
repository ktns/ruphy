module RuPHY
	module GSL
		class GSLError < Exception
			module Errno
			end

			include GSLError::Errno

			def initialize reason, file, line, errno
				super "GSLError:#{errorstr(errno)} @ #{file} l#{line}; #{reason}"
			end
		end
	end
end
