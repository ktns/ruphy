class RuPHY::BasisSet::Parser::Gaussian94
rule
BLOCKS
  : COMMENTBLOCK
	| ELEMENTBLOCK
	| BLOCKS BLOCKS { result = val[0].merge val[1] }
COMMENTBLOCK
	: COMMENTLINE EOB { result = {} }
	| EOL EOB {result = {} }
	| COMMENTLINE COMMENTBLOCK {result = {} }
	| EOL COMMENTBLOCK {result = {} }
ELEMENTBLOCK
	: ELEMENTS_LINE SHELLS EOB {
		result = val[0].each_with_object({}) do |element, result|
			result.merge!({element.to_sym => val[1]})
		end
	}
ELEMENTS_LINE
	: ELEMENT_ALL ZERO EOL { result = [val[0]] }
	| ELEMENT_ALL ELEMENTS_LINE { result = val[1].unshift val[0] }
ELEMENT_ALL
	: ELEMENT
	| ELEMENT_OR_ANGULAR_MOMENTUM
ZERO
	: NUMBER { raise "Unexpected `%p', expected 0" % val[0] unless val[0] == 0}
SHELLS
	: ANGULAR_MOMENTUM_ALL NUMBER NUMBER EOL PRIMITIVES {
		c, n = val[4].count, val[1]
		raise '# primitive gaussians (%d) != NGauss(%d)!' % [c,n] unless c==n
		s = val[2]
		result = [RuPHY::BasisSet::LCAO::Gaussian::Shell.new(
			val[0],
			*val[4].map do |a,d|
				[a*s, d]
			end.transpose, :center
		)]
	}
	| SHELLS SHELLS { result = val[0] + val[1] }
ANGULAR_MOMENTUM_ALL
	: ANGULAR_MOMENTUM { result = ANGULAR_MOMENTA.index(val[0]) }
	| ELEMENT_OR_ANGULAR_MOMENTUM { result = ANGULAR_MOMENTA.index(val[0]) }
PRIMITIVES
	: NUMBER NUMBER EOL { result = [[val[0], val[1]]] }
	| NUMBER NUMBER EOL PRIMITIVES {
		result = [[val[0], val[1]]] + val[3]
	}
end
---- inner
ELEMENTS = RuPHY::Elements.symbols.map(&:to_s)
ANGULAR_MOMENTA = %w<S P D F G H I>
ANGULAR_MOMENTA_ALL = ANGULAR_MOMENTA.inject([[]]) do |p, m|
	p + p.map{|s| s + [m]}
end.reject(&:empty?).map(&:join)
ELEMENT_OR_ANGULAR_MOMENTUM = ELEMENTS & ANGULAR_MOMENTA

ELEMENTS_R = Regexp.union(ELEMENTS)
ANGULAR_MOMENTA_R = Regexp.union(ANGULAR_MOMENTA_ALL)
ELEMENT_OR_ANGULAR_MOMENTUM_R = Regexp.union(ELEMENT_OR_ANGULAR_MOMENTUM)

def debug= on
	@yydebug = on ? true : false
end

def parse str
	@q = []
	until str.empty?
		case str
		when /\A*!.*\n/
			@q << [:COMMENTLINE, $&]
		when /\A\*{4,}\s*\n/
			@q << [:EOB, $&]
		when /\A\n/
			@q << [:EOL, $&]
		when /\A\s+/
		when /\A\d+\.\d+\b/
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
