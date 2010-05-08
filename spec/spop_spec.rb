require File.dirname(__FILE__) + '/spec_helper.rb'

module RuPHY::GSL
	module SPOP
		module Hamiltonian
			describe Hydrogenic do
				describe '.new' do
					it 'should be public' do
						Hydrogenic.should respond_to :new
					end
				end
			end
		end
	end
end
