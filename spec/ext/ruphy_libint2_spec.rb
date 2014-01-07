require 'spec_helper'
require 'ruphy_libint2'

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
      @ams    = 4.times.collect{rand(0..3)}
      @shells = 4.times.collect{|i|double("shell#{i}", :angular_momentum=>@ams[i])}
      @max_am = @ams.max
    end

    subject{described_class.new(*@shells)}

    its(:max_angular_momentum){is_expected == @max_am}
  end
end
