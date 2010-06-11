require File.dirname(__FILE__) + '/../../spec_helper.rb'

module RuPHY::GSL
	module SPOP
		module Hamiltonian
			describe Hydrogenic do
				it 'should respond_to :new' do
					Hydrogenic.should respond_to :new
				end
			end
		end
	end
end
