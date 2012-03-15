require File.join(File.dirname(__FILE__), %w|.. .. spec_helper.rb|)

describe RuPHY::Theory::RHF do
	describe 'on Helium atom' do
		it 'should yield -2.859895425 hartree of total energy'
	end
end

describe ::Matrix do
	subject{described_class}

	it{should_not respond_to :new}
end

shared_examples_for(RuPHY::Theory::RHF::Matrix) do
	subject{described_class}

	it {should respond_to :new}
end

describe RuPHY::Theory::RHF::Matrix do
	it_behaves_like RuPHY::Theory::RHF::Matrix
end

describe RuPHY::Theory::RHF::CoefficientMatrix do
	it_behaves_like RuPHY::Theory::RHF::Matrix
end

describe RuPHY::Theory::RHF::FockianMatrix do
	it_behaves_like RuPHY::Theory::RHF::Matrix
end

describe RuPHY::Theory::RHF::OverlapMatrix do
	it_behaves_like RuPHY::Theory::RHF::Matrix
end

describe RuPHY::Theory::RHF::OneElectronMatrix do
	it_behaves_like RuPHY::Theory::RHF::Matrix
end

describe RuPHY::Theory::RHF::TwoElectronMatrix do
	it_behaves_like RuPHY::Theory::RHF::Matrix
end
