require 'ruphy/mo/basis'

module RuPHY
  module Theory
    module RHF

      # Returns energies:Array and MO vectors:Matrix
      def solve_roothaan_equation fock, overlap
        raise ArgumentError, 'Fock matrix is not a hermitian matrix!' unless fock.hermitian?
        raise ArgumentError, 'Overlap matrix is not a hermitian matrix!' unless overlap.hermitian?
        _, energies_matrix, vectors = *(overlap**-0.5*fock*overlap**-0.5).eigensystem
        energies = energies_matrix.each(:diagonal).to_a
        vectors = Matrix[*(0...vectors.column_size).sort_by do |i|
          energies[i]
        end.map do |i|
          vectors.row(i)
        end]
        vectors*=overlap**-0.5
        return [energies.sort, vectors]
      end

      class MO
        include RuPHY::MO
        include RHF

        def setup_number_of_electrons geometry, opts = {}
          @n = opts.fetch(:number_of_electrons) do
            geometry.total_nuclear_charge - opts.fetch(:total_charge, 0)
          end
          raise TypeError, "Expected #{Integer}, got #{number_of_electrons.class}" unless @n.is_a? Integer
          raise ArgumentError, "Expected positive integer, got #{@n}" unless @n > 0
        end

        def initialize geometry, basis, opts = {}
          setup_number_of_electrons geometry, opts
          @geometry = geometry
          case basis
          when MO::Basis
            @basis = basis
          else
            @basis = basis.span(:geometry => geometry, :number_of_electrons => @n)
          end
          @basis.freeze
          @vectors = nil
          @energies = nil
        end

        attr_reader :n, :geometry, :basis, :vectors, :energies
        alias number_of_electrons n

        # Return the number of the basis function set
        def size_of_basis
          basis.size
        end
        alias m size_of_basis

        # Return overlap matrix of the basis functions
        def overlap
          basis.overlap
        end

        # Return core Hamiltonian matrix calculated from basis functions
        def core_hamiltonian
          basis.core_hamiltonian
        end

        # Calculate density matrix from MO vectors and number of electrons
        def density_matrix
          raise VectorNotCalculatedError.new(self) unless vectors
          # assume vectors are sorted by energy level in ascending order
          vectors.transpose *
            Matrix.diagonal(*[2]*(n/2)+[0]*(vectors.column_size-n/2)) *
            vectors
        end

        # Calculate Mulliken population matrix from the density matrix and the overlap matrix
        def mulliken_matrix
          Matrix.build(size_of_basis) do |i,j|
            density_matrix[i,j] * overlap[i,j]
          end
        end

        # Solve Roothaan-Hall equation for the given Fock matrix and the ovelap matrix,
        # and update energy eigenvalues and MO vectors
        def fock_matrix= fock
          @energies, @vectors = *solve_roothaan_equation(fock, basis.overlap)
        end

        class VectorNotCalculatedError < Exception
          def initialize mo
            "%p has no MO vector yet!" % mo
          end
        end
      end

      class Solver
        def initialize geometry, basisset
          raise NotImplementedError
        end
      end
    end
  end
end
