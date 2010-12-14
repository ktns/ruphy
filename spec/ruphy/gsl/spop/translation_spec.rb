require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module RuPHY::GSL
	module SPOP
		describe Translation do
			before do
				@spwf = random_spwf_hydrogenic
			end

			describe '.new(0, 0, 0)' do
				it 'should be identity operator' do
					(Translation.new(0,0,0) * @spwf).should_be_equivalent @spwf
				end
			end

			describe '#inverse' do
				before do
					@spop_translation = Translation.new(rand(), rand(), rand())
				end

				it 'should return inverted translation' do
					(@spop_translation.inverse*(@spop_translation*@spwf)).should_be_equivalent @spwf
				end
			end
		end
	end
end
