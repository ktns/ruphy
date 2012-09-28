require File.join(File.dirname(__FILE__), %w|.. spec_helper.rb|)

describe RuPHY::Elements do
	subject do
		RuPHY::Elements
	end
	describe '[]' do
		it 'should invoke get_elem_data' do
			subject.should_receive(:get_elem_data).and_return([0,:hoge,0])
			RuPHY::Elements[:hoge] 
		end
	end
end
