module RuPHY
  module BasisSet
    class Base
      include Enumerable
    end

    class SimpleList < Base
      def initialize *bases
        @bases = bases
      end

      def basis i
        @bases[i]
      end

      def each &block
        @bases.each &block
      end
    end
  end
end
