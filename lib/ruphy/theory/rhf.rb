require 'ruphy/mo/basis'

module RuPHY
  module Theory
    module RHF
      include Math

      # Calculate Fock matrix from given basis, density matrix, and geometry.
      def fock_matrix basis, density, geometry
        f = Matrix.build(basis.size) do |i,j|
          density.each_with_index.inject(0) do |jk, (d, k, l)|
            jk + d * (basis.electron_repulsion(i,j,k,l) - basis.electron_repulsion(i,k,j,l)/2)
          end
        end + basis.core_hamiltonian(geometry)
        f += f.transpose
        f /= 2
      end

      # Returns energies:Array and MO vectors:Matrix
      def solve_roothaan_equation fock, overlap
        raise ArgumentError, 'Fock matrix is not a hermitian matrix!' unless fock.hermitian?
        raise ArgumentError, 'Overlap matrix is not a hermitian matrix!' unless overlap.hermitian?
        solve_GSEP fock, overlap
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

        # Return kinetic componetn of core Hamiltonian matrix calculated from basis functions
        def kinetic
          basis.kinetic
        end

        # Return core Hamiltonian matrix calculated from basis functions
        def core_hamiltonian
          basis.core_hamiltonian(geometry)
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

        # Return Fock matrix calculated from the current density matrix
        def fock_matrix density = self.density_matrix
          super basis, density, geometry
        end

        # Construct the Fock matrix from the given density matrix
        # and solve it
        def density_matrix= density
          self.fock_matrix = fock_matrix(density)
        end

        # Return nuclear repulsion energy calculated from molecule geometry.
        def nuclear_repulsion_energy
          geometry.nuclear_repulsion_energy
        end

        # Return total electronic energy calculated from current MO vectors.
        def total_electronic_energy
          raise EnergyNotCalculatedError.new(self) unless energies
          energies.first(n/2).inject(:+) +
            core_hamiltonian.inner_product(density_matrix)/2
        end

        # Return total energy including nuclear repulsion.
        def total_energy
          nuclear_repulsion_energy + total_electronic_energy
        end
        alias E total_energy

        # Return virial ratio calculated from current MO vectors.
        def virial_ratio
          t = density_matrix.inner_product(kinetic)
          v = total_energy - t
          return - v / t
        end

        class VectorNotCalculatedError < Exception
          def initialize mo
            "%p has no MO vector yet!" % mo
          end
        end

        class EnergyNotCalculatedError < Exception
          def initialize mo
            "%p has no MO energy yet!" % mo
          end
        end
      end

      class Solver
        def initial_guess_type
          :fock
        end

        def initial_guess
          @mo.core_hamiltonian
        end

        def initialize geometry, basisset
          @mo = MO.new(geometry, basisset)
        end
        attr_reader :mo
        alias result mo

        def next_density_matrix previous_density_matrix
          previous_density_matrix
        end

        def iterate
          begin
            @prev_density = mo.density_matrix
            mo.density_matrix = next_density_matrix(@prev_density)
            @delta_density = mo.density_matrix - @prev_density
          rescue MO::VectorNotCalculatedError
            case initial_guess_type
            when :fock
              @mo.fock_matrix = initial_guess
            when :density
              @mo.density_matrix = initial_guess
            end
            @delta_density = @mo.density_matrix * -1
          end
        end
        attr_reader :delta_density
      end
    end
  end
end
