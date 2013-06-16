module RuPHY
  module BasisSet
    include Enumerable
    class SimpleList
      include BasisSet
      def initialize *bases
        @bases = bases
      end

      def basis i
        @bases[i]
      end

      def each &block
        @bases.each(&block)
      end
    end
  end
end
