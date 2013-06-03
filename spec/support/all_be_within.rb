module RSpec::Matchers
  module AllBeWithin
    class AllBeWithin
      def initialize delta
        @delta = delta.to_f
      end

      def matches? actual
        @actual = actual
        raise ArgumentError, "missing of(expected_value)!" unless defined? @expected
        @exception = actual.find do |elem|
          begin
            @actual_delta = elem - @expected
          rescue Exception
            raise ArgumentError, 'Cannot subtract `%p\' from `%p\'!' % [elem, @expected]
          end
          @actual_delta = @actual_delta.abs
          @actual_delta > @delta
        end
        not @exception
      end

      def of expected
        @expected = expected
        return self
      end

      def percent_of expected
        @expected = expected
        @delta /= 1000
        return self
      end

      def failure_message_for_should
        "expected %p to be within %p of %p but actual delta = %p" % [@exception, @delta, @expected, @actual_delta]
      end

      def description
        'all be within %p of %p' % [@delta, @expected]
      end
    end

    def all_be_within delta
      AllBeWithin.new delta
    end
  end

  include AllBeWithin
end
