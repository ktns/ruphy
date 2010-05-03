class RuPHY::GSL::SPOP::Hamiltonian
	# Represents Hamiltonian for a hydrogenic atom.
	class Hydrogenic < self
		# Initializes Hamiltonian for a hydrogenic atom with Atomic Number z.
		def initialize z = 1
			@Z = z
		end
		
		class << self
			public :new
		end
	end
end
