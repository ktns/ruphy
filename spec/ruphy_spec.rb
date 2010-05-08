require File.dirname(__FILE__) + '/spec_helper.rb'

describe RuPHY do
	describe '.complex' do
		it 'should return Complex' do
			RuPHY.should respond_to(:complex)
			RuPHY.complex(1,0).should be_kind_of(Complex)
		end

		it 'should fail if non-numeric was given' do
			lambda do
				RuPHY.complex('1',0)
			end.should raise_error TypeError
		end
	end
end
