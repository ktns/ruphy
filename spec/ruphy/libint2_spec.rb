require 'spec_helper'
require 'ruphy/libint2'

describe RuPHY::Libint2::Evaluator do
  describe '#get_result_for_aos' do
    let(:shell0){double(:shell0, contrdepth:1, azimuthal_quantum_numbers:[0], center:random_vector)}
    let(:shell1){double(:shell1, contrdepth:1, azimuthal_quantum_numbers:[2], center:random_vector)}
    let(:ao0){double(:ao0, angular_momentum:0, momenta:[0,0,0], shell:shell0, normalization_factor:0, shell_ao_normalization_factor_ratio:0)}
    let(:ao1){double(:ao1, angular_momentum:0, momenta:[0,0,0], shell:shell0, normalization_factor:0, shell_ao_normalization_factor_ratio:0)}
    let(:ao2){double(:ao2, angular_momentum:0, momenta:[0,0,0], shell:shell0, normalization_factor:0, shell_ao_normalization_factor_ratio:0)}
    let(:ao3){double(:ao3, angular_momentum:2, momenta:[0,1,1], shell:shell1, normalization_factor:0, shell_ao_normalization_factor_ratio:0)}
    let(:results){double(:results)}
    class Test < described_class
      def initialize r,s,l
        @results = r
        @shells  = s
        @l       = l
        super *s.zip(l).flatten
      end
      def results
        @results
      end
    end

    let(:evaluator) do
      Test.new results, [shell0, shell0, shell1, shell0], [0,0,2,0]
    end

    specify do
      expect(results).to receive(:[]).with([[0,0,0],[0,0,0],[0,1,1],[0,0,0]]).and_return(0)
      evaluator.get_result_for_aos(ao0,ao1,ao2,ao3)
    end
  end
end
