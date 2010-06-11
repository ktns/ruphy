require File.dirname(__FILE__) + '/../../spec_helper.rb'

module RuPHY::GSL
	module SPWF
		describe SPWF do
			describe '#+' do
				describe SPWF do
					before do
						@spwf1 = mock_spwf(:spwf1)
						@spwf2 = mock_spwf(:spwf2)
					end

					it "should invoke #{Combination}.new" do
						Combination.should_receive(:new).with(@spwf1, @spwf2).and_return :combination
						(@spwf1 + @spwf2).should == :combination
					end
				end
			end

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
						@spwf = mock_spwf
					end

					it "should invoke #{Operated}.new" do
						multiplier = Complex(rand(), rand())
						Operated.should_receive(:new).with(SPOP::Multiplier.new(multiplier), @spwf)
						@spwf * multiplier
					end
				end
			end
		end
	end
end
