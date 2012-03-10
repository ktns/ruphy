require File.dirname(__FILE__) + '/../../../../spec_helper.rb'

module RuPHY::GSL
	module SPOP
		module Hamiltonian
			describe "#{Hydrogenic}" do
				describe '#initialize' do
					it "should raise #{ArgumentError} if given non-positive number" do
						lambda do
							Hydrogenic.new(-100 * rand())
						end.should raise_error ArgumentError
					end

					it "should not raise error if given positive number" do
						lambda do
							Hydrogenic.new(99 * rand() +1)
						end.should_not raise_error
					end
				end
			end
		end
	end
end
