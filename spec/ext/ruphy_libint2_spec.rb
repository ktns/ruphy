require 'spec_helper'
require 'ruphy/libint2'

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
      @ams    = 4.times.collect{rand(4)}
      @shells = 4.times.collect do |i|
        double("shell#{i}",
               :angular_momentum=>@ams[i],
               :contrdepth=>1,
               :center=>random_vector,
               :zeta=>rand()).tap { |s|
          allow(s).to receive(:each_primitive_shell).and_yield(1, s.zeta)
        }
      end
      @max_am = @ams.max
    end

    subject{described_class.new(*@shells)}

    its(:max_angular_momentum){is_expected == @max_am}

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
  end
end
