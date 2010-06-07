require File.dirname(__FILE__) + '/spec_helper.rb'

module RuPHY::GSL
	module SPOP
		describe Combination do
			before do
				@spops = Array.new(4){Multiplier.new(rand())}
				@spop_combination = Combination.new(*@spops)
			end

			describe 'operated on a function' do
				before do
					@spwf = random_spwf_hydrogenic
				end

				it 'should return summation of original operators operated on the function' do
					10.times do
						coord = random_coordinate
						(@spop_combination * @spwf).eval(*coord).should ==
							@spops.inject(0){|s,o| s + (o * @spwf).eval(*coord)}
					end
				end
			end
		end
	end
end
