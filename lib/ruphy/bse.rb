require 'ruphy'
require 'soap/wsdlDriver'

module RuPHY
	module BSE
		class Downloader
			def initialize
				@wsdl = SOAP::WSDLDriverFactory.new(
					'http://purl.oclc.org/NET/EMSL/BSE/services')
			end
		end
	end
end
