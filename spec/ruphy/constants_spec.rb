require File.join(File.dirname(__FILE__), %w|.. spec_helper.rb|)

describe RuPHY::Constants do
	it 'should define Da' do
		described_class::Da.should be_kind_of Numeric
	end
end
