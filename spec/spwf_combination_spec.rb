require File.dirname(__FILE__) + '/spec_helper.rb'

module RuPHY::GSL
	module SPWF
		class Combination
			describe Combination do
				describe '#eval' do
					before do
						@spwf1, @spwf2 = Hydrogenic.new(2,1,1,1),Hydrogenic.new(2,1,-1,1)
						@spwf = @spwf1 + @spwf2
					end

					it 'should return summation of operands' do
						10.times do
							r, theta, phy = random_coordinate()
							@spwf.eval(r,theta,phy).should ==
								@spwf1.eval(r,theta,phy) + @spwf2.eval(r,theta,phy)
						end
					end
				end
			end
		end
	end
end
