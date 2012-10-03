require 'ruphy/elements'
require 'open-uri'

module RuPHY::ElementData
	module NIST
		URI_BASE = 'http://physics.nist.gov/cgi-bin/Compositions/stand_alone.pl?ele=%s&ascii=ascii2&isotype=some'

		module GrepFirst
			def grep_first pat
				find do |el|
					pat === el
				end
				return $1
			end
		end

		private
		def read_data ele
			open(URI_BASE%ele) do |io|
				io.extend GrepFirst
				yield io
			end
		end

		def read_elem_data io
			z = io.grep_first(/^Atomic Number = (\d+)/) or
				raise 'Cannot find Atomic Number!'
			sym = io.grep_first(/^Atomic Symbol = ([A-Z][a-z]*)$/) or
				raise 'Cannot find Atomic Symbol!'
			m = io.grep_first(/^Standard Atomic Weight = (.+)$/) or
				raise 'Cannot find Standard Atomic Weight!'
			return z.to_i,
				sym.to_sym,
				m.to_f
		end

		def get_elem_data key
			read_data key.to_s do |io|
				return read_elem_data io
			end
		end

		def read_all_data &block
			read_data '&all=all', &block
		end

		public
		def download_all_elements_data
			read_all_data do |io|
				begin
				loop do
					z,sym,m = data = read_elem_data(io)
					key?(z) and next
					entry RuPHY::Element.new(*data)
				end
				rescue
					io.eof? and return
					raise $!
				end
			end
		end
	end

	RuPHY::Elements.extend NIST
end
