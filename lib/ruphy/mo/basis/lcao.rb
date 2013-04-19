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
          raise NotImplementedError
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
