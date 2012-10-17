require File.join(File.dirname(__FILE__), %w|.. spec_helper.rb|)

describe RuPHY::Orbital do
	describe '.new' do
		subject{lambda{described_class.new}}

		it{should raise_error NoMethodError}
	end
end
