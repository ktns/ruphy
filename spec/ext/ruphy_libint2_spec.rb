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

if RuPHY::Libint2::compiled?
  describe RuPHY::Libint2::Evaluator do
    before do
      @ls     = 4.times.collect{rand(0..3)}
      @shells = 4.times.collect do |i|
        double("shell#{i}",
               :azimuthal_quantum_numbers=>[@ls[i]],
               :contrdepth=>1,
               :center=>random_vector,
               :zeta=>rand()).tap { |s|
                 allow(s).to receive(:each_primitive_shell).with(@ls[i]).and_yield(1, s.zeta)
        }
      end
      @max_l = @ls.max
      @tot_l = @ls.reduce(&:+)
    end

    let(:contrdepth){@shells.map(&:contrdepth).reduce(&:*)}
    let(:evaluator){described_class.new(*@shells.zip(@ls).flatten)}
    let(:shells){evaluator.original_shell_order.map{|i|@shells[i]}}
    subject{evaluator}

    its(:max_azimuthal_quantum_number){is_expected == @max_l}

    its(:total_azimuthal_quantum_number){is_expected == @tot_l}

    describe '#each_primitive_shell' do
      it 'should invoke block with correct arguments' do
        subject.each_primitive_shell do |c, z0, z1, z2, z3|
          expect(c).to eq 1
          expect(z0).to eq shells[0].zeta
          expect(z1).to eq shells[1].zeta
          expect(z2).to eq shells[2].zeta
          expect(z3).to eq shells[3].zeta
        end
      end
    end

    describe '#each_primitive_shell_with_index' do
      it 'should invoke block with correct arguments' do
        subject.each_primitive_shell_with_index do |i, c, z0, z1, z2, z3|
          expect(i).to eq 0
          expect(c).to eq 1
          expect(z0).to eq shells[0].zeta
          expect(z1).to eq shells[1].zeta
          expect(z2).to eq shells[2].zeta
          expect(z3).to eq shells[3].zeta
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
        expect(ax).to eq(shells[0].center[0])
        expect(ay).to eq(shells[0].center[1])
        expect(az).to eq(shells[0].center[2])
        expect(bx).to eq(shells[1].center[0])
        expect(by).to eq(shells[1].center[1])
        expect(bz).to eq(shells[1].center[2])
        expect(cx).to eq(shells[2].center[0])
        expect(cy).to eq(shells[2].center[1])
        expect(cz).to eq(shells[2].center[2])
        expect(dx).to eq(shells[3].center[0])
        expect(dy).to eq(shells[3].center[1])
        expect(dz).to eq(shells[3].center[2])
      end

      it 'should set contrdepth' do
        expect{subject.initialize_evaluator}.to change{subject.contrdepth}.from(0).to(contrdepth)
      end
    end

    describe '#evaluate' do
      context 'after #initialize_evaluator' do
        subject{evaluator.initialize_evaluator}

        specify{expect{subject.evaluate}.not_to raise_error}

        specify{expect{subject.evaluate}.to change{subject.results}.from(nil).to(Hash)}
      end
    end

    describe '.[]' do
      let(:key){ 8.times.map{|i| double('key%d'%i)} }
      it 'should invoke .new' do
        expect(described_class).to receive(:new).with(*key)
        described_class[*key]
      end
    end
  end
end
