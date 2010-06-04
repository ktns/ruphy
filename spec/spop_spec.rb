require File.dirname(__FILE__) + '/spec_helper.rb'

module RuPHY::GSL
	module SPOP
		describe SPOP do
			describe '#*'do
				it 'should invoke SPWF::Operated' do
					@spop = mock_spop
					@spwf = mock_spwf
					SPWF::Operated.should_receive(:new).with(@spop, @spwf)
					@spop * @spwf
				end
			end
		end

		module Hamiltonian
			describe Hydrogenic do
				it 'should respond_to :new' do
					Hydrogenic.should respond_to :new
				end
			end
		end
	end
end
