module RuPHY::GSL::SPOP::Hamiltonian
	# Represents Hamiltonian for a hydrogenic atom.
	class Hydrogenic
		# Initializes Hamiltonian for a hydrogenic atom with Atomic Number z.
		include RuPHY::GSL::SPOP::Hamiltonian

		def initialize z = 1
			@Z = z
		end
	end
end
