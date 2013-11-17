require 'rspec/expectations'

RSpec::Matchers.define :all_be_finite do |expected|
  match do |actual|
    @exception = actual.find do |elem|
      not elem.to_f.finite?
    end
    not @exception
  end

  failure_message_for_should do |actual|
    "expected %p to finite value" % [@exception]
  end

  failure_message_for_should_not do |actual|
    "expected %p to be include not finite value" % [actual]
  end
end
