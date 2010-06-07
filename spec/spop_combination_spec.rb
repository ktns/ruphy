require File.dirname(__FILE__) + '/spec_helper.rb'

module RuPHY::GSL
	module SPOP
		describe Combination do
			before do
				@spops = Array.new(4){Multiplier.new(rand())}.sort_by(&:hash)
				@spop_combination = Combination.new(*@spops)
			end

			describe 'operated on a function' do
				before do
					@spwf = random_spwf_hydrogenic
				end

				it 'should return summation of original operators operated on the function' do
					10.times do
						begin
							coord = random_coordinate
							(@spop_combination * @spwf).eval(*coord).should ==
								@spops.inject(0){|s,o| s + (o * @spwf).eval(*coord)}
						rescue GSLError
							retry if $!.errno == GSLError::Errno::GSL_EUNDRFLW
							raise $!
						end
					end
				end
			end

			describe 'with permutated operators' do
				before do
					@spop_combinations = @spops.permutation.collect do |spops|
						Combination.new(*spops)
					end
				end

				it 'should not be equal each other' do
					@spop_combinations.combination(2) do |spop1, spop2|
						spop1.should_not equal spop2
					end
				end

				it 'should be eql each other' do
					@spop_combinations.combination(2) do |spop1, spop2|
						spop1.should eql spop2
					end
				end

				it 'should be == each other' do
					@spop_combinations.combination(2) do |spop1, spop2|
						spop1.should == spop2
					end
				end

				it 'should have same hash as aother' do
					@spop_combinations.combination(2) do |spop1, spop2|
						spop1.hash.should == spop2.hash
					end
				end
			end
		end
	end
end
