require File.dirname(__FILE__) + '/spec_helper.rb'

module RuPHY::GSL
	module	SPOP
		describe Multiplier do
			before do
				@spwf = random_spwf_hydrogenic
				@multiplier = Multiplier.new(rand())
				@multiplied = @multiplier * @spwf
			end

			it 'should multiply spwf by @multiplier' do
				10.times do
					begin
						coord = random_coordinate
						@multiplied.eval(*coord).should == @spwf.eval(*coord) * @multiplier.multiplier
					rescue GSLError
						retry if $!.errno == GSLError::Errno::GSL_EUNDRFLW
					end
				end
			end

			describe "* #{Numeric}" do
				it "should return #{Multiplier} with multiplied multiplier" do
					[rand(),Complex.new(rand(),rand())].each do |num|
						multiplied = @multiplier * num
						multiplied.should be_kind_of(Multiplier)
						multiplied.multiplier.should == @multiplier.multiplier * num
					end
				end
			end

			describe "/ #{Numeric}" do
				it "should return #{Multiplier} with devided multiplier" do
					[rand(),Complex.new(rand(),rand())].each do |num|
						multiplied = @multiplier / num
						multiplied.should be_kind_of(Multiplier)
						multiplied.multiplier.should == @multiplier.multiplier / num
					end
				end
			end

			describe "** #{Numeric}" do
				it "should return #{Multiplier} with raised multiplier" do
					[rand(),Complex.new(rand(),rand())].each do |num|
						multiplied = @multiplier ** num
						multiplied.should be_kind_of(Multiplier)
						multiplied.multiplier.should == @multiplier.multiplier ** num
					end
				end
			end
		end

		describe "identical #{Multiplier}s" do
			before :all do
				@multiplier1 = Multiplier.new(rand)
				@multiplier2 = Multiplier.new(@multiplier1.multiplier)
			end

			it 'shuld not equal each other' do
				@multiplier1.should_not equal @multiplier2
			end

			it 'should return same hash' do
				@multiplier1.hash.should == @multiplier2.hash
			end

			it 'shuld == each other' do
				@multiplier1.should == @multiplier2
			end

			it 'shuld eql each other' do
				@multiplier1.should eql @multiplier2
			end
		end

		describe "#{Numeric} * #{Multiplier}" do
			before do
				@multiplier = Multiplier.new(rand())
				@num = rand()
			end

			it "should return #{Multiplier} with multiplied multiplier" do
				(@num * @multiplier).should == Multiplier.new(@num * @multiplier.multiplier)
			end
		end

		describe "#{Numeric} / #{Multiplier}" do
			before do
				@multiplier = Multiplier.new(rand())
				@num = rand()
			end

			it "should return #{Multiplier} with devided multiplier" do
				(@num / @multiplier).should == Multiplier.new(@num / @multiplier.multiplier)
			end
		end
	end
end
