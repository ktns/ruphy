RSpec::Matchers.define :all_be_kind_of do |expected|
	match do |actual|
		@exception = actual.find do |elem|
			not elem.kind_of? expected
		end
		not @exception
	end

	failure_message_for_should do |actual|
		"expected %p to be kind of %s" % [@exception, expected]
	end
end
