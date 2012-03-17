require File.join(File.dirname(__FILE__), %w|.. spec_helper.rb|)

describe RuPHY::BasisSet::SimpleList do
	before do
		@basis_set = described_class.new(
			@spwf1=stub(:spwf1), @spwf2=stub(:spwf2))
	end

	subject {@basis_set}

	it {should respond_to :each}

	it 'should enumerate basis functions' do
		@spwf1.should_receive :test
		@spwf2.should_receive :test
		subject.each do |b|
			b.test
		end
	end

	it '#map should return an array' do
		subject.map do |b|
			b
		end.should be_instance_of Array
	end
end
