require File.dirname(__FILE__) + '/spec_helper.rb'

module RuPHY::GSL
	module SPWF
		class Multiplied
			describe Multiplied do
				describe 'identical pair' do
					before do
						@spwfs =
							[
								[
									Hydrogenic.new(1,0,0,1) * -1,
									-Hydrogenic.new(1,0,0,1)
								],[
									Multiplied.new(Hydrogenic.new(2,1,-1,3), 1, -1),
									Hydrogenic.new(2,1,-1,3) * Complex(1, -1)
								]
							]
					end

					it 'should not equal' do
						@spwfs.each do |spwf1,spwf2|
							spwf1.should_not equal spwf2
						end
					end

					it 'should have same hash' do
						@spwfs.each do |spwf1,spwf2|
							spwf1.hash.should == spwf2.hash
						end
					end

					it 'should eql' do
						@spwfs.each do |spwf1,spwf2|
							spwf1.should eql spwf2
						end
					end

					it 'should ==' do
						@spwfs.each do |spwf1,spwf2|
							spwf1.should == spwf2
						end
					end
				end
			end
		end
	end
end
