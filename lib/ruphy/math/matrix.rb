require 'matrix'
require 'delegate'

module RuPHY
  module Math
    class Matrix < SimpleDelegator
      def initialize matrix
        @delegate_sd_obj = matrix
      end

      def coerce other
        [ other, @delegate_sd_obj ]
      end

      class << self
        private :new

        def method_missing method, *args
          new(::Matrix.send(method,*args))
        end
      end
    end
  end

  Matrix = Math::Matrix
end
