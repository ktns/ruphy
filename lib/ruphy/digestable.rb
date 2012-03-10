require 'digest/md5'

module RuPHY
	# module included by classes whose hash is calculated by digest
	module Digestable
		# returns Digest::Base representing hash of self
		#
		# require method 'digest_args' to be defined in class
		def digest
			digest=Digest::MD5.new
			digest_update(digest, digest_args)
			return digest
		end

		# update digest with args
		def digest_update digest, *args
			args.each do |arg|
				case arg
				when Digest::Base
					raise TypeError, 'Unexpected Digest::Base in arguments!'
				when Array
					digest_update(digest,*args.flatten)
				when Enumerable
					digest_update(digest,*args)
				when Module
					digest.update(arg.to_s)
				when String
					digest.update(arg)
				when RuPHY::Digestable
					arg.digest_update(digest)
				when Complex
					digest_update(digest, arg.real, arg.imag)
				when Float
					digest.update([arg].pack('d'))
				else
					digest.update(arg.to_s)
				end
			end
		end

		# returns hash integer calculated by digest string
		def hash
			digest().hexdigest.to_i(16)
		end
	end
end
