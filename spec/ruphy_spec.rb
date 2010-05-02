require File.dirname(__FILE__) + '/spec_helper.rb'

describe RuPHY::GSL::SPWF do 
	describe '.new' do
		it 'should be private' do
			RuPHY::GSL::SPWF.should_not respond_to :new
			lambda do
				RuPHY::GSL::SPWF.new
			end.should raise_error NoMethodError, /private method `new' called/
		end
	end
end
