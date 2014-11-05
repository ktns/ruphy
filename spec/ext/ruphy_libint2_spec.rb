require 'spec_helper'
require 'ruphy/libint2'
require 'ruphy/basisset/lcao/gaussian/shell'

if defined? RuPHY::Libint2
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
        @shells, @ls = described_class::reorder_shells(*@shells.zip(@ls).flatten).each_slice(2).to_a.transpose
        @max_l = @ls.max
        @tot_l = @ls.reduce(&:+)
      end

      let(:contrdepth){@shells.map(&:contrdepth).reduce(&:*)}
      let(:evaluator){described_class.new(*@shells.zip(@ls).flatten)}
      subject{evaluator}

      its(:max_azimuthal_quantum_number){is_expected == @max_l}

      its(:total_azimuthal_quantum_number){is_expected == @tot_l}

      describe '#each_primitive_shell' do
        it 'should invoke block with correct arguments' do
          subject.each_primitive_shell do |c, z0, z1, z2, z3|
            expect(c).to eq 1
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
            expect(c).to eq 1
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
        before :each do
          described_class.clear
        end

        let(:key){ 8.times.map{|i| double('key%d'%i)} }
        it 'should invoke .new' do
          expect(described_class).to receive(:new).with(*key)
          described_class[*key]
        end

        it 'should return same object for equivalent permutations' do
          described_class.each_equivalent_shell_order(*@shells.zip(@ls)).map do |*args|
            described_class[*args.flatten]
          end.uniq.tap{|e| expect(e).to have(1).item}
        end
      end
    end

    describe RuPHY::AO::Gaussian::Contracted::Product do
      context 'with %s included' % RuPHY::Libint2::ContractedProduct do
        let(:contrdepth){ 4.times.map{ rand(1..3) }}
        let(:coeffs){     4.times.map{|i| contrdepth[i].times.map{ rand(-5.0..5.0) }}}
        let(:zetas){      4.times.map{|i| contrdepth[i].times.map{ rand(0.0..5.0) }}}
        let(:l){          4.times.map{ rand(0..RuPHY::Libint2::OptAM) }}
        let(:momenta){ l.map{|l| random_angular_momenta(l) }}
        let(:center){ 4.times.map{ random_vector }}
        let(:shell) do
          4.times.map do |i|
            double(
              "shell#{i}",
              :azimuthal_quantum_numbers=>[l[i]],
              :contrdepth=>coeffs[i].size,
              :center=>center[i],
              :zeta=>rand()
            ).tap do |s|
              coeffs[i].zip(zetas[i]).inject(
                allow(s).to receive(:each_primitive_shell).with(l[i])
              ) do |r, (c, z)|
                r.and_yield(c, z)
              end
            end
          end
        end
        class ContractedAO < RuPHY::AO::Gaussian::Contracted
          def initialize shell, *args
            super *args
            @shell = shell
          end
          attr_reader :shell
        end

        let(:ao) do
          4.times.map do |i|
            ContractedAO.new shell[i], coeffs[i], zetas[i], momenta[i], center[i]
          end
        end
        4.times{ |i| let("ao#{i}".to_sym){ ao[i] }}

        def described_class
          @described_class ||= super.dup.include RuPHY::Libint2::ContractedProduct
        end

        specify{ expect( described_class ).to include RuPHY::Libint2::ContractedProduct }

        let(:product0){ described_class::new(ao0, ao1) }
        let(:product1){ described_class::new(ao2, ao3) }

        describe '#electron_repulsion' do
          subject{product0.electron_repulsion product1}

          pending do 'to be implemented'
            it{ is_expected.to eq (ao0*ao1).electron_repulsion(ao2*ao3) }
          end
        end
      end
    end
  end
end
