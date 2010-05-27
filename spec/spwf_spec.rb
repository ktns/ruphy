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

				describe Numeric do
					before :each do
						@spwf = mock(:spwf)
						@spwf.extend(SPWF)
					end

					it "should invoke #{Multiplied}.new" do
						multiplier = Complex(rand(), rand())
						Multiplied.should_receive(:new).with(@spwf, multiplier)
						@spwf * multiplier
					end
				end
			end
		end
	end
end
