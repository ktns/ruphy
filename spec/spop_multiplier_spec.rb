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
		end
	end
end
