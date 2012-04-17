require File.join(File.dirname(__FILE__), %w'.. .. spec_helper.rb')

describe RuPHY::Orbital::Gaussian do

end

describe RuPHY::Orbital::Gaussian::Primitive do
	describe '.new' do
		it 'should accept zeta, orders, and center' do
			lambda do
				described_class.new 1.0, [0,0,0], Vector[0,0,0]
			end.should_not raise_error
		end

		it 'should not accept wrong dimension of orders' do
			lambda do
				described_class.new 1.0, [0,0,0,0], Vector[0,0,0]
			end.should raise_error ArgumentError
		end

		it 'should not accept wrong dimension of orders' do
			lambda do
				described_class.new 1.0, [0,0,0], Vector[0,0,0,0]
			end.should raise_error ArgumentError
		end
	end
end
