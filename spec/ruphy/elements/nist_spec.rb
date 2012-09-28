require File.join(File.dirname(__FILE__), %w|.. .. spec_helper.rb|)
require 'ruphy/elements/nist'

describe RuPHY::ElementData::NIST do
	it 'should be included by RuPHY::Elements' do
		RuPHY::Elements.singleton_class.ancestors.should include described_class
	end

	describe '#get_elem_data' do
		subject do
			stub().extend described_class
		end

		context 'with H' do
			it do
				subject.send(:get_elem_data,:H)
			end
		end
	end
end
