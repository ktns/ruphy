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

	#context 'with Hydrogenic solution on He nucleus' do
	#	before do
	#		@basis_set = RuPHY::BasisSet::SimpleList.new(* 2.times.map do |i|
	#
	#		end)
	#	end

	#	subject do
	#		RuPHY::Theory::RHF::OverlapMatrix.new(@basis_set)
	#	end

	#	it {should be_within(1e-5).of(Matrix.identity(2))}
	#end
end

describe RuPHY::Theory::RHF::OneElectronMatrix do
	it_behaves_like RuPHY::Theory::RHF::Matrix

	context 'with Hydrogenic solution basis and Hamiltonian on He nucleus' do
		#before do
		#	@basis_set = RuPHY::BasisSet::SimpleList.new(* 2.times.map do |i|
    #
		#	end)
    #
		#	@spop = RuPHY::GSL::SPOP::Hamiltonian::Hydrogenic.new(2)
		#end
    #
		#subject do
		#	RuPHY::Theory::RHF::OneElectronMatrix.new(@basis_set, @spop)
		#end
    #
		#it {should be_diagnoal}
	end
end

describe RuPHY::Theory::RHF::TwoElectronMatrix do
	it_behaves_like RuPHY::Theory::RHF::Matrix
end

describe RuPHY::Theory::RHF::Solver do
	it 'should not raise error on initialization' do
		pending 'Not yet implemented' do
			lambda do
				described_class.new nil, nil
			end.should_not raise_error
		end
	end
end
