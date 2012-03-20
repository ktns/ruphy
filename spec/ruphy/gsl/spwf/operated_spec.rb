require File.dirname(__FILE__) + '/../../../spec_helper.rb'

describe RuPHY::GSL::SPWF::Operated do
	before do
		@op = RuPHY::GSL::SPOP::Multiplier.new(1)
		@wf = RuPHY::GSL::SPWF::Hydrogenic.new(1,0,0,1);
	end

	subject {described_class.new(@op, @wf)}

	it 'should have proper instance variables' do
		class << subject
			@spwf.should == @wf
			@spop.should == @op
		end
	end
end
