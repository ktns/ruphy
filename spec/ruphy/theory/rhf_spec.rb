require 'spec_helper'
require 'ruphy/basisset/STO3G'

describe RuPHY::Theory::RHF do
  include Math
  include described_class

  class Vector
    def abs
      r
    end
  end
  class Matrix
    def abs
      (self.transpose.conj * self).trace**0.5
    end
  end

  describe 'on Helium atom' do
    it 'should yield -2.859895425 hartree of total energy'
  end

  describe '#solve_roothaan_equation' do
    let(:theta){rand()*Math::PI/2}
    let(:u){Matrix[[cos(theta),sin(theta)],[-sin(theta),cos(theta)]]}
    let(:energies){Vector[*[-rand(),-rand()].sort]}
    let(:fock){f = u.transpose * Matrix.diagonal(*energies) * u; (f+f.transpose)/2}
    let(:solved){solve_roothaan_equation(fock, overlap)}
    let(:delta_vectors){u-solved.last}

    context 'with identity as overlap' do
      let(:overlap){Matrix.identity(2)}

      it 'should yield correct energies' do
        Vector[*solved.first].should be_within(1e-12).of(energies)
      end

      it 'should yield correct vectors' do
        subject = solved.last
        subject = RuPHY::Matrix.diagonal(*subject.each(:diagonal).map{|d| d <=> 0})*subject
        subject.should be_within(1e-12).of(u)
      end
    end

    context 'with non-identity as overlap' do
      let(:overlap){o=Matrix.build(2){rand()}; o+o.transpose+Matrix::identity(2)}

      it 'should yield vectors diagonal with overlap as metric' do
        _, subject = solved
        expect(subject * overlap * subject.transpose).to be_within(1e-8).of(Matrix.identity(subject.column_size))
      end
    end
  end
end

describe RuPHY::Theory::RHF::MO do
  let(:mo){described_class.new(*arg)}
  subject{mo}

  if defined? ::TestMol && defined? RuPHY::BasisSet::STO3G
    context "with #{::TestMol} and #{RuPHY::BasisSet::STO3G}" do
      let(:arg){[::TestMol, RuPHY::BasisSet::STO3G]}

      creating_it{should_not raise_error}

      describe '#fock_matrix=' do
        it 'should call solve_roothaan_equation' do
          fock, basis, overlap = mock(:fock), mock(:basis), mock(:overlap)
          mo.stub(:basis).and_return(basis)
          basis.stub(:overlap).and_return(overlap)
          mo.should_receive(:solve_roothaan_equation).with(fock,overlap)
          mo.fock_matrix = fock
        end
      end
    end
  end
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
