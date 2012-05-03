require File.join(File.dirname(__FILE__), %w|.. spec_helper.rb|)
require 'ruphy/bse'

describe RuPHY::BSE::Downloader do
	describe '.new' do
		it 'should not raise error' do
			lambda do
				described_class.new
			end.should_not raise_error
		end
	end
end
