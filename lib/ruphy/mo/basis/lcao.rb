module RuPHY
  module MO
    module Basis
      class LCAO
        include Basis
        def initialize geometry, basisset
          @geometry = geometry
          @shells = geometry.each_atom.each_with_object({}) do |atom, shells|
            shells[atom] = basisset.shells(atom.element).map do |shell|
              Shell.new shell, atom
            end
          end
        end

        def shells
          @shells.values.flatten
        end

        # Return total number of the atomic orbital functions
        def size
          shells.inject(0) do |size, shell|
            size + shell.aos.size
          end
        end
        alias m size
        alias dimension size

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

        def nuclear_attraction geometry=@geometry
          aos = self.aos
          hash={}
          Matrix.build(aos.size) do |i,j|
            hash[i.hash+j.hash] ||= geometry.inject(0.0) do |v, atom|
              aos[i].nuclear_attraction(aos[j], atom) + v
            end
          end
        end

        def core_hamiltonian geometry=@geometry
          kinetic - nuclear_attraction(geometry)
        end

        # Returns <ao_i(r_1)*ao_j(r_1)|r_12^-1|ao_k(r_2)*ao_l(r_2)>
        def electron_repulsion i,j,k,l
          (aos[i]*aos[j]).electron_repulsion(aos[k]*aos[l])
        end

        class Shell < SimpleDelegator
          def initialize abst_shell, center
            abst_shell.respond_to?(:aos) or
              raise TypeError, "Expected %p to have method aos, but not" % [abst_shell]
            shell = abst_shell.dup.extend ActualShell
            shell.instance_eval do
              @center = center
            end
            __setobj__ shell
          end

          module ActualShell
            attr_reader :center
          end
        end
      end
    end
  end
end
