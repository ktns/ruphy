require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module RuPHY::GSL
	module SPWF
		class Combination
			describe Combination do
				before do
					@spwfs = Array.new(4){random_spwf_hydrogenic()}.sort_by(&:hash)
					@spwf_combination = Combination.new(*@spwfs)
				end

				describe '.new' do
					it 'should raise error if invalid argument specified' do
						[nil, false].each do |n|
							lambda do
								Combination.new(n,n)
							end.should raise_error ArgumentError
						end
						lambda do
							Combination.new :hoge, :fuga
						end.should raise_error TypeError
					end
				end

				describe '#eval' do
					it 'should return summation of operands' do
						@spwf_combination.should_be_equivalent do |r, theta, phy|
							@spwfs.inject(0){|s, f| s + f.eval(r,theta,phy)}
						end
					end
				end

				describe 'with permutated functions' do
					before do
						@spwf_combinations = @spwfs.permutation.collect do |spwfs|
							Combination.new(*spwfs)
						end
					end

					it 'should not be equal each other' do
						@spwf_combinations.combination(2) do |spwf1, spwf2|
							spwf1.should_not equal spwf2
						end
					end

					it 'should be eql each other' do
						@spwf_combinations.combination(2) do |spwf1, spwf2|
							spwf1.should eql spwf2
						end
					end

					it 'should be == each other' do
						@spwf_combinations.combination(2) do |spwf1, spwf2|
							spwf1.should == spwf2
						end
					end

					it 'should have same hash as another' do
						@spwf_combinations.combination(2) do |spwf1, spwf2|
							spwf1.hash.should == spwf2.hash
						end
					end
				end
			end
		end
	end
end
