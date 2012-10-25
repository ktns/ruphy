require File.join(File.dirname(__FILE__), %w|.. spec_helper.rb|)

describe RuPHY::Element do
	let(:element){described_class.new(0,:hoge,0)}

	let(:same_element){described_class.new(0,:hoge,0)}

	let(:other_element){described_class.new(0,:piyo,0)}

	subject{element}

	it do
		should == same_element
	end

	it do
		should be_eql same_element
	end

	it do
		should_not == other_element
	end

	it do
		should_not be_eql other_element
	end

	describe '#hash' do
		subject{element.hash}

		it do
			should == same_element.hash
		end

		it do
			should_not == other_element.hash
		end
	end
end

describe 'RuPHY::Elements' do
	subject do
		RuPHY::Elements
	end
	describe '#[]' do
		it 'should invoke get_elem_data' do
			subject.should_receive(:get_elem_data).and_return([0,:hoge,0])
			RuPHY::Elements[:hoge] 
		end
	end

	describe '#symbols' do
		subject do
			RuPHY::Elements.symbols
		end

		it{should_not include_a String}

		it{should_not include_a Numeric}

		it{should have_at_least(100).items}
	end
end
