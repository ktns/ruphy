require 'spec_helper'

describe RuPHY::Element do
  let(:element){described_class.new(0,:hoge,0)}

  let(:same_element){described_class.new(0,:hoge,0)}

  let(:other_element){described_class.new(0,:piyo,0)}

  subject{element}

  it do
    is_expected.to eq(same_element)
  end

  it do
    is_expected.to be_eql same_element
  end

  it do
    is_expected.not_to eq(other_element)
  end

  it do
    is_expected.not_to be_eql other_element
  end

  its(:z){is_expected.to eq subject.Z}

  its(:atomic_number){is_expected.to eq subject.Z}

  describe '#hash' do
    subject{element.hash}

    it do
      is_expected.to eq(same_element.hash)
    end

    it do
      is_expected.not_to eq(other_element.hash)
    end
  end

  its(:to_yaml){is_expected.not_to include 'sym:'}

  its(:to_yaml){is_expected.not_to include 'u:'}

  context 'deserialized from YAML' do
    let(:original){RuPHY::Elements.values.sample}
    subject do
      YAML.load(original.to_yaml)
    end

    it {is_expected.to eq(original)}

    it {is_expected.to be_eql original}

    its(:hash){is_expected.to eq original.hash}

    its(:m){is_expected.to eq original.m}
  end
end
