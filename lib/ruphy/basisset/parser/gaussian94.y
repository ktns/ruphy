class RuPHY::BasisSet::Parser::Gaussian94
rule
BLOCKS
	: COMMENTBLOCK { result = { :comment => val[0] } }
	| ELEMENTBLOCK
	| BLOCKS BLOCKS {
		result = val[0].merge val[1] do |k, v1, v2|
			case k
			when :comment, *ELEMENTS
				v1 + v2
			else
				raise Racc::ParseError, "Unexpected object `%p' appeared as element!" % k
			end
		end
	}
COMMENTBLOCK
	: COMMENTLINE EOB { result = val[0] }
	| EOL EOB { result = '' }
	| COMMENTLINE COMMENTBLOCK { result = val.join }
	| EOL COMMENTBLOCK { result = val[1] }
ELEMENTBLOCK
	: ELEMENTS_LINE SHELLS EOB {
		result = {}.tap do |result|
			val[0].each do |element|
				result.merge!({element.to_sym => val[1]})
			end
		end
	}
ELEMENTS_LINE
	: ELEMENT_ALL EOL { result = [val[0]] }
	| ELEMENT_ALL ZERO EOL { result = [val[0]] }
	| ELEMENT_ALL ELEMENTS_LINE { result = val[1].unshift val[0] }
ELEMENT_ALL
	: ELEMENT
	| ELEMENT_OR_ANGULAR_MOMENTUM
ZERO
	: NUMBER { raise "Unexpected `%p', expected 0" % val[0] unless val[0] == 0}
SHELL
	: ANGULAR_MOMENTUM_ALL NUMBER NUMBER EOL PRIMITIVES {
		momenta, ngauss, scale_factor, _, primitives = val
		raise '# primitive gaussians (%d) != NGauss(%d)!' % [primitives.count,ngauss] unless primitives.count == ngauss
		zetas, coeffs = primitives.map do |z,c|
			[z*scale_factor**2, c]
		end.transpose()
		coeffs=coeffs.transpose
		result = RuPHY::BasisSet::LCAO::Gaussian::Shell.new(
			val[0], coeffs, zetas
		)
	}
SHELLS
	: SHELL { result = [val[0]] }
	| SHELLS SHELL { result = val[0] << val[1] }
ANGULAR_MOMENTUM_ALL
	: ANGULAR_MOMENTUM { result = parse_angular_momenta_all(val[0]) }
	| ELEMENT_OR_ANGULAR_MOMENTUM { result = parse_angular_momenta_all(val[0]) }
PRIMITIVES
	: NUMBER COEFFS EOL {
		zeta, coeffs = val
		result = []
		result.unshift([zeta, coeffs])
	}
	| NUMBER COEFFS EOL PRIMITIVES {
		zeta, coeffs, _, result = val
		result.unshift([zeta, coeffs])
	}
COEFFS 
	: NUMBER { result = [ val[0] ]}
	| NUMBER COEFFS { result = [ val[0] ] + val[1] }
end
---- header
require 'ruphy/basisset/lcao/gaussian'
---- inner
ELEMENTS = RuPHY::Elements.symbols.map(&:to_s)
ANGULAR_MOMENTA = %w<S P D F G H I>
ANGULAR_MOMENTA_ALL = ANGULAR_MOMENTA.inject([[]]) do |p, m|
	p + p.map{|s| s + [m]}
end.reject(&:empty?).map(&:join)
ELEMENT_OR_ANGULAR_MOMENTUM = ELEMENTS & ANGULAR_MOMENTA

ELEMENTS_R = /-?#{Regexp.union(ELEMENTS)}/
ANGULAR_MOMENTA_R = Regexp.union(ANGULAR_MOMENTA_ALL)
ELEMENT_OR_ANGULAR_MOMENTUM_R = Regexp.union(ELEMENT_OR_ANGULAR_MOMENTUM)

def debug= on
	@yydebug = on ? true : false
end

def parse str
	@q = []
	until str.empty?
		case str
		when /\A!.*\n/
			@q << [:COMMENTLINE, $&]
		when /\A\*{4,}\s*\n/
			@q << [:EOB, $&]
		when /\A\s*\n/
			@q << [:EOL, $&]
		when /\A-?\d+\.\d+D[+-]\d+\b/
			@q << [:NUMBER, $&.tr('D','e').to_f]
		when /\A\s+/
		when /\A-?\d+\.\d+\b/
			@q << [:NUMBER, $&.to_f]
		when /\A\d+\b/
			@q << [:NUMBER, $&.to_i]
		when /\A(#{ELEMENT_OR_ANGULAR_MOMENTUM_R})\b/
			@q << [:ELEMENT_OR_ANGULAR_MOMENTUM, $1]
		when /\A-?(#{ELEMENTS_R})\b/
			@q << [:ELEMENT, $1]
		when /\A(#{ANGULAR_MOMENTA_R})\b/
			@q << [:ANGULAR_MOMENTUM, $1]
		else
			raise 'Cannot Parse `%s\'' % str.split("\n").first
		end
		str=$'
	end
	@q.push [false, '$end']
	return RuPHY::BasisSet::LCAO::Gaussian.new do_parse()
end

def next_token
	@q.shift
end

def parse_angular_momenta_all m
	m.split('').map{|s| ANGULAR_MOMENTA.index(s)}
end
