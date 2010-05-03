require File.dirname(__FILE__) + '/spec_helper.rb'

module RuPHY::GSL
	describe SPOP do
		describe '.new' do
			it 'should be private' do
				SPOP.should_not respond_to :new
				lambda do
					SPOP.new
				end.should raise_error NoMethodError, /private method `new' called/
			end
		end
	end

	class SPOP::Hamiltonian
		describe Hydrogenic do
			describe '.new' do
				it 'should be public' do
					Hydrogenic.should respond_to :new
				end
			end
		end
	end
end
