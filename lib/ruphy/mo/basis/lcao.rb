module RuPHY
  class MO
    class Basis
      class LCAO < Basis
        def initialize geometry, basisset
          @shells = geometry.each_atom.each_with_object({}) do |atom, shells|
            shells[atom] = basisset.shells(atom.element).map do |shell|
              Shell.new shell, atom
            end
          end
        end

        def shells
          @shells.values.flatten
        end

        def aos
          shells.flat_map do |shell|
            shell.aos
          end
        end

        def overlap
          aos = self.aos
          hash={}
          Matrix.build(aos.size) do |i,j|
            hash[i.hash+j.hash] ||= aos[i].overlap(aos[j])
          end
        end

        def kinetic
          aos = self.aos
          hash={}
          Matrix.build(aos.size) do |i,j|
            hash[i.hash+j.hash] ||= aos[i].kinetic(aos[j])
          end
        end

        def nuclear_attraction
          raise NotImplementedError
        end

        def core_hamiltonian
          kinetic - nuclear_attraction
        end

        class Shell < SimpleDelegator
          def initialize abst_shell, center
            shell = abst_shell.dup.extend ActualShell
            shell.center = center
            __setobj__ shell
          end

          module ActualShell
            attr_accessor :center
          end
        end
      end
    end
  end
end
