require 'spec_helper'

describe RuPHY::Geometry::Molecule do
  shared_examples_for 'proper molecule' do
    its(:each_atom){is_expected.to all_be_kind_of RuPHY::Geometry::Atom}

    its(:each){is_expected.to all_be_kind_of RuPHY::Geometry::Atom}
  end

  context 'with xyz' do
    before :all do
      @xyz = 
      <<-EOF
      3
      Oxidane
      H          0.63109       -0.02651        0.47485
      O          0.14793        0.02998       -0.34219
      H         -0.77901       -0.00348       -0.13266
      EOF
    end

    let(:correct_size){3}

    shared_examples_for "molecule read from xyz" do
      its(:size){is_expected.to eq correct_size}

      its(:nuclear_repulsion_energy){is_expected.to be_within(1e-5).of(9.24861786)}

      it{is_expected.to have(3).atoms}

      its(:total_nuclear_charge){is_expected.to eq 10}
    end

    context 'string' do
      subject{described_class.new(@xyz,'xyz')}

      it_should_behave_like "molecule read from xyz"

      it_should_behave_like 'proper molecule'
    end

    context 'file' do
      before(:all) do
        @file = Tempfile.new(['ruphy_test','xyz'])
        @file.puts @xyz
        @file.close(false)
      end

      subject{described_class.new(@file.path)}

      it_should_behave_like "molecule read from xyz"

      after(:all) do
        @file.close(true)
      end

      it_should_behave_like 'proper molecule'
    end
  end

  context 'with wrong format string' do
    subject{lambda { described_class.new('', 'wrong_format') }}

    it{ is_expected.to raise_error ArgumentError }
  end
end

describe RuPHY::Geometry::Atom do
  let(:center){Array.new(3){rand()}}
  subject{described_class.new(dummy_atom(*center))}

  its(:vector){is_expected.to eq Vector[*center] * described_class::Angstrom}
end
