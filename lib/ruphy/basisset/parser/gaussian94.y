class RuPHY::BasisSet::Parser::Gaussian94
rule
BLOCKS
  : COMMENTBLOCK
	| ELEMENTBLOCK
	| BLOCKS BLOCKS
COMMENTBLOCK
	: COMMENTLINE EOB
	| EOL EOB
	| COMMENTLINE COMMENTBLOCK
	| EOL COMMENTBLOCK
ELEMENTBLOCK
	: ELEMENT_ALL NUMBER EOL SHELLS EOB
ELEMENT_ALL
	: ELEMENT
	| ELEMENT_OR_ANGULAR_MOMENTUM
SHELLS
	: ANGULAR_MOMENTUM_ALL NUMBER NUMBER EOL PRIMITIVES
ANGULAR_MOMENTUM_ALL
	: ANGULAR_MOMENTUM
	| ELEMENT_OR_ANGULAR_MOMENTUM
PRIMITIVES
	: NUMBER NUMBER EOL
	| NUMBER NUMBER EOL PRIMITIVES
end
---- inner
ELEMENTS = RuPHY::Elements.symbols.map(&:to_s)
ANGULAR_MOMENTUMS = %w<S P D F G H I>
ELEMENT_OR_ANGULAR_MOMENTUM = ELEMENTS & ANGULAR_MOMENTUMS

ELEMENTS_R = Regexp.union(ELEMENTS)
ANGULAR_MOMENTUMS_R = Regexp.union(ANGULAR_MOMENTUMS)
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
		when /\A(#{ANGULAR_MOMENTUMS_R})\b/
			@q << [:ANGULAR_MOMENTUM, $1]
		else
			raise 'Cannot Parse `%s\'' % str.split("\n").first
		end
		str=$'
	end
	@q.push [false, '$end']
	do_parse
end

def next_token
	@q.shift
end
