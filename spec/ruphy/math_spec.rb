require File.join(File.dirname(__FILE__), %w|.. spec_helper.rb|)

describe RuPHY::Math do
	describe '.boys' do
		subject{described_class.boys(r,m)}

		context 'r=0,m=0' do
			let(:r){0};let(:m){0}

			it {should == 1}
		end
	end
end
