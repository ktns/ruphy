require 'openbabel'
require 'matrix'
require 'ruphy/constants'
require 'delegate'

module RuPHY
  module Geometry
    class Molecule
      include Enumerable

      def initialize source, format = 'xyz'
        obconv = OpenBabel::OBConversion.new
        obconv.set_in_format(format) or raise ArgumentError, '%p is not a format registered in OpenBabel!' % format
        @obmol = OpenBabel::OBMol.new
        if File.exist? source
          obconv.read_file(@obmol, source)
        else
          obconv.read_string(@obmol, source)
        end
      end

      def size
        @obmol.num_atoms
      end

      def each_atom
        if block_given?
          iter = @obmol.begin_atoms
          atom = @obmol.begin_atom(iter)
          begin
            yield Atom.new(atom)
          end while atom = @obmol.next_atom(iter)
        else
          to_enum(:each_atom)
        end
      end
      alias each each_atom

      def nuclear_repulsion_energy
        each_atom.to_a.combination(2).inject(0) do |e, (a1, a2)|
          v1, v2 = [a1,a2].map(&:vector)
          r = (v1-v2).r
          e + a1.get_atomic_num * a2.get_atomic_num / r
        end
      end

      def total_nuclear_charge
        each_atom.inject(0) do |charge, atom|
          charge + atom.get_atomic_num
        end
      end

      def atoms
        each_atom.to_a
      end
    end

    class Atom < Delegator
      include RuPHY::Constants

      def initialize obatom
        @obatom = obatom
      end

      def __getobj__
        return @obatom
      end

      def to_s
        '%s@[%.5f, %.5f, %.5f]' % [element, get_x, get_y, get_z]
      end

      def element
        Elements[get_atomic_num]
      end

      def inspect
        "#<#{self.class}: #{to_s}>"
      end

      def vector
        Vector[get_x, get_y, get_z] * Angstrom
      end
    end
  end
end
