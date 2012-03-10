module RuPHY
	module GSL
		class GSLError < Exception
			module Errno
			end

			include GSLError::Errno

			attr_reader :reason, :file, :line, :errno, :errstr
			def initialize reason, file, line, errno
				@reason,@file,@line,@errno,@errstr = reason, file, line, errno, errorstr(errno)
				super "GSLError:#{@errstr} @ #{file} l#{line}; #{reason}"
			end
		end
	end
end
