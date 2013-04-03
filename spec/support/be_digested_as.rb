require 'digest'

RSpec::Matchers.define :be_digested_as do |expected|
  chain :using do |algorithm|
    case algorithm
    when Digest::Base
      @algorithm = algorithm
    when Module
      @algorithm = algorithm.new
    when String, Symbol
      @algorithm = Digest.const_get(algorithm.to_sym).new
    else
      raise TypeError, "`%p' cannot be converted to Digest::Base or name of a hash function!" % algorithm
    end
  end

  match do |actual|
    @algorithm ||= Digest::MD5.new
    @algorithm.reset << actual
    case expected.size
    when @algorithm.digest_length
      @algorithm.digest == expected
    when @algorithm.digest_length * 2
      @algorithm == expected
    else
      raise 'Hash string lengths mismatched! (%d != %d)' % [expected.size, @algorithm.digest_length]
    end
  end

  failure_message_for_should do |actual|
    "Digest mismatched using %s" % @algorithm.class
  end
end
