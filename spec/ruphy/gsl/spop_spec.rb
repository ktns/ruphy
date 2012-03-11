require File.dirname(__FILE__) + '/../../spec_helper.rb'

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

			describe "* nil" do
				it "should raise #{TypeError}" do
					lambda do
						mock_spop * nil
					end.should raise_error NotImplementedError
				end
			end

			describe "\b" do
				before do
					@spop1 = mock_spop :spop1
					@spop2 = mock_spop :spop2
				end

				describe "+ #{SPOP}" do
					it "should invoke #{Combination}.new" do
						SPOP::Combination.should_receive(:new).with(@spop1, @spop2)
						@spop1 + @spop2
					end
				end

				describe "- #{SPOP}" do
					it "should invoke #{SPOP} + (-#{SPOP})" do
						@spop1.should_receive(:+).with(:inverted)
						@spop2.should_receive(:-@).with(no_args()).and_return(:inverted)
						@spop1 - @spop2
					end
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

		SPOP.constants.collect do |name|
			SPOP.const_get(name)
		end.select do |cls|
			cls.kind_of?(Class) && cls < SPOP
		end.each do |cls|
			describe "#{cls}" do
				subject{cls}

				it "should include #{RuPHY::Digestable}" do
					subject.should < RuPHY::Digestable
				end

				it "should have instance method 'digest_args'" do
					subject.method_defined?(:digest_args).should be_true
				end
			end
		end
	end
end
