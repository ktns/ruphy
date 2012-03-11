require File.dirname(__FILE__) + '/../../spec_helper.rb'

module RuPHY::GSL
	module SPWF
		describe SPWF do
			describe '#+' do
				describe SPWF do
					before do
						@spwf1 = mock_spwf(:spwf1)
						@spwf2 = mock_spwf(:spwf2)
					end

					it "should invoke #{Combination}.new" do
						Combination.should_receive(:new).with(@spwf1, @spwf2).and_return :combination
						(@spwf1 + @spwf2).should == :combination
					end
				end
			end

			describe '#*'do
				describe 'SPWF' do
					before :each do
						@spwf1 , @spwf2 = Array.new(2){Hydrogenic.new(1,0,0,1)}
					end

					it 'should return Complex' do
						(@spwf1 * @spwf2).should be_kind_of Complex
					end
				end

				describe Numeric do
					before :each do
						@spwf = mock_spwf
					end

					it "should invoke #{Operated}.new" do
						multiplier = Complex(rand(), rand())
						Operated.should_receive(:new).with(SPOP::Multiplier.new(multiplier), @spwf)
						@spwf * multiplier
					end
				end
			end
		end

		SPWF.constants.collect do |name|
			SPWF.const_get(name)
		end.select do |cls|
			cls.kind_of?(Class) && cls < SPWF
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
