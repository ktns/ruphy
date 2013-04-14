module RuPHY
  class MO
    class Basis
      class LCAO < Basis
        def initialize geometry, basisset
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
