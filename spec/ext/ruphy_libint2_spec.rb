require 'spec_helper'
require 'ruphy/libint2'
require 'ruphy/basisset/lcao/gaussian/shell'

describe RuPHY::Libint2 do
  if described_class.compiled?
    describe described_class::Evaluator do
      describe 'initializer' do
        let(:testarg){rand()}
        let(:testclass) do
          described_class.clone.class_eval do
            def initialize arg
              throw :Evaluator_Initialized, arg
            end
            self
          end
        end

        specify{ expect{testclass.new(testarg)}.to throw_symbol(:Evaluator_Initialized, testarg) }
      end
    end
  else
    $stderr.puts "Libint2 extension is not compiled"
  end
end

CoeffMap = RuPHY::BasisSet::LCAO::Gaussian::Shell::CoeffMap
if RuPHY::Libint2::compiled?
  describe RuPHY::Libint2::Evaluator do
    before do
      @ls     = 4.times.collect{[*0..4].sample(rand(1..5))}
      @cmaps  = 4.times.collect do |i|
        CoeffMap[@ls[i].zip([1]*@ls[i].size)]
      end
      @shells = 4.times.collect do |i|
        double("shell#{i}",
               :azimuthal_quantum_numbers=>@ls[i],
               :contrdepth=>1,
               :center=>random_vector,
               :zeta=>rand()).tap { |s|
          allow(s).to receive(:each_primitive_shell).and_yield(@cmaps[i], s.zeta)
        }
      end
      @tot_cmap  = @cmaps.reduce(&:*)
      @csmap     = described_class::CoeffMap.new.append(@tot_cmap)
      @max_l     = @ls.flatten.max
      @max_tot_l = @ls.map(&:max).reduce(&:+)
    end

    let(:contrdepth){@shells.map(&:contrdepth).reduce(&:*)}
    let(:evaluator){described_class.new(*@shells)}
    subject{evaluator}

    its(:max_azimuthal_quantum_number){is_expected == @max_l}

    its(:max_total_azimuthal_quantum_number){is_expected == @max_tot_l}

    describe '#each_primitive_shell' do
      it 'should invoke block with correct arguments' do
        subject.each_primitive_shell do |c, z0, z1, z2, z3|
          expect(c).to eq @tot_cmap
          expect(z0).to eq @shells[0].zeta
          expect(z1).to eq @shells[1].zeta
          expect(z2).to eq @shells[2].zeta
          expect(z3).to eq @shells[3].zeta
        end
      end
    end

    describe '#each_primitive_shell_with_index' do
      it 'should invoke block with correct arguments' do
        subject.each_primitive_shell_with_index do |i, c, z0, z1, z2, z3|
          expect(i).to eq 0
          expect(c).to eq @tot_cmap
          expect(z0).to eq @shells[0].zeta
          expect(z1).to eq @shells[1].zeta
          expect(z2).to eq @shells[2].zeta
          expect(z3).to eq @shells[3].zeta
        end
      end
    end

    describe '#initialize_evaluator' do
      it 'should not raise error' do
        expect{subject.initialize_evaluator}.not_to raise_error
      end

      it 'should set coordinates of centers' do
        subject.initialize_evaluator
        ax, ay, az, bx, by, bz, cx, cy, cz, dx, dy, dz = subject.packed_center_coordinates.unpack('d12')
        expect(ax).to eq(@shells[0].center[0])
        expect(ay).to eq(@shells[0].center[1])
        expect(az).to eq(@shells[0].center[2])
        expect(bx).to eq(@shells[1].center[0])
        expect(by).to eq(@shells[1].center[1])
        expect(bz).to eq(@shells[1].center[2])
        expect(cx).to eq(@shells[2].center[0])
        expect(cy).to eq(@shells[2].center[1])
        expect(cz).to eq(@shells[2].center[2])
        expect(dx).to eq(@shells[3].center[0])
        expect(dy).to eq(@shells[3].center[1])
        expect(dz).to eq(@shells[3].center[2])
      end

      it 'should set coefficients map' do
        expect{subject.initialize_evaluator}.to change{subject.coefficients_map}.from(nil).to(described_class::CoeffMap)
        expect(subject.coefficients_map.keys).to eq @tot_cmap.keys
      end

      it 'should set contrdepth' do
        expect{subject.initialize_evaluator}.to change{subject.contrdepth}.from(0).to(contrdepth)
      end
    end

    describe '#evaluate' do
      let(:ls){@ls.map( &:sample )}
      context 'after #initialize_evaluator' do
        subject{evaluator.initialize_evaluator}

        specify{pending; expect{subject.evaluate(*ls)}.not_to raise_error}
      end
    end
  end
end
