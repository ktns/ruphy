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
