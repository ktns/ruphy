require File.join(File.dirname(__FILE__), %w|.. .. spec_helper.rb|)
require 'ruphy/elements/nist'

describe RuPHY::ElementData::NIST do
	it 'should be included by RuPHY::Elements' do
		RuPHY::Elements.singleton_class.ancestors.should include described_class
	end

	describe '#get_elem_data' do
		subject do
			stub(:get_elem_data).extend described_class
		end

		context 'with H' do
			before :all do
				@z,@sym,@m = subject.send(:get_elem_data,:H)
			end

			it 'should return proper atomic number' do
				@z.should == 1
			end

			it 'should return proper atomic symbol' do
				@sym.should == :H
			end

			it 'should return proper atomic weight' do
				@m.should be_within(0.01).of(1)
			end
		end
	end
end
