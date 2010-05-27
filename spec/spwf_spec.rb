require File.dirname(__FILE__) + '/spec_helper.rb'

module RuPHY::GSL
	module SPWF
		describe SPWF do
			describe '#*'do
				describe 'SPWF' do
					before :each do
						@spwf1 , @spwf2 = Array.new(2){Hydrogenic.new(1,0,0,1)}
					end

					it 'should return Complex' do
						(@spwf1 * @spwf2).should be_kind_of Complex
					end
				end
			end
		end
	end
end
