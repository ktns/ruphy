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
      let(:overlap){o=Matrix.build(2){rand()}; o+o.transpose+Matrix::identity(2)*2}

      it 'should yield vectors diagonal with overlap as metric' do
        _, subject = solved
        expect(subject * overlap * subject.transpose).to be_within(1e-8).of(Matrix.identity(subject.column_size))
      end
    end
  end

  describe '#fock_matrix' do
    if defined? ::TestMol && defined? RuPHY::BasisSet::STO3G
      context 'with TestMol and STO3G' do
        let(:basis){RuPHY::BasisSet::STO3G.span(:geometry => ::TestMol, :number_of_electrons => 2)}
        let(:density_matrix){Matrix::build(2){0.60245569e+00}}
        let(:correct_fock_matrix){Matrix::build(2){|i,j| i==j ? -0.36602603e+00 : -0.59429997e+00 }}
        it 'should return correct Fock matrix' do
          extend described_class
          f = fock_matrix(basis, density_matrix, ::TestMol)
          expect(f).to be_within(1e-7).of(correct_fock_matrix)
        end
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

      describe '#fock_matrix' do
        context 'before fock_matrix= called' do
          it 'should raise VectorNotCalculatedError' do
            expect{mo.fock_matrix}.to raise_error RuPHY::Theory::RHF::MO::VectorNotCalculatedError
          end
        end
        context 'after fock_matrix= called' do
          it 'should raise VectorNotCalculatedError' do
            mo.fock_matrix = Matrix::identity(mo.size_of_basis)
            expect{mo.fock_matrix}.not_to raise_error RuPHY::Theory::RHF::MO::VectorNotCalculatedError
          end
        end
        context 'after density_matrix= called' do
          it 'should raise VectorNotCalculatedError' do
            mo.density_matrix = Matrix::identity(mo.size_of_basis)
            expect{mo.fock_matrix}.not_to raise_error RuPHY::Theory::RHF::MO::VectorNotCalculatedError
          end
        end
      end

      describe '#density_matrix=' do
        let(:density_matrix){Matrix::build(2){0.60245569e+00}}
        let(:fock_matrix){Matrix::build(2){|i,j| i==j ? -0.36602603e+00 : -0.59429997e+00 }}
        it 'should yield correct solution' do
          mo.density_matrix = density_matrix
          mo.fock_matrix.should be_within(1e-7).of(fock_matrix)
        end

        it 'should call solve_roothaan_equation' do
          mo.should_receive(:solve_roothaan_equation)
          mo.density_matrix=density_matrix
        end
      end

      context 'and without MO calculated' do
        describe '#mulliken_matrix' do
          subject{mo.mulliken_matrix}
          calling_it{should raise_error described_class::VectorNotCalculatedError}
        end
      end

      context 'and with MO calculated' do
        describe '#mulliken_matrix' do
          subject{mo.fock_matrix=mo.core_hamiltonian; mo.mulliken_matrix}

          it 'should be summed up to number_of_electrons' do
            subject.each.reduce(:+).should be_within(1e-8).of(mo.number_of_electrons)
          end
        end
      end

      describe '#total_energy' do
        let(:density_matrix){Matrix::build(2){0.60245569e+00}}

        context 'before mo is calculated' do
          it 'should raise EnergyNotCalculatedError' do
            expect{mo.total_energy}.to raise_error described_class::EnergyNotCalculatedError
          end
        end

        context 'after mo is calculated' do
          it 'should return correct value' do
            mo.density_matrix=density_matrix
            expect(mo.total_energy).to be_within(1e-7).of(-1.1167593)
          end
        end
      end

      its(:nuclear_repulsion_energy){should be_within(1e-7).of(0.7151043355)}

      describe '#virial_ratio' do
        context 'after mo is calculated' do
          let(:density_matrix){Matrix::build(2){0.60245569e+00}}

          it 'should approximatly equal to 2' do
            mo.density_matrix=density_matrix
            expect(mo.virial_ratio).to be_within(10).percent_of(2)
          end
        end
      end
    end
  end
end

describe RuPHY::Theory::RHF::Solver do
  if defined? ::TestMol && defined? RuPHY::BasisSet::STO3G
    let(:solver){described_class.new(::TestMol, RuPHY::BasisSet::STO3G)}
    subject{solver}

    creating_it{should_not raise_error}

    it 'should be able to solve the problem' do
      10.times do
        solver.iterate.abs < 1e-7 and break
      end
      solver.delta_density.abs < 1e-7
    end
  end
end
