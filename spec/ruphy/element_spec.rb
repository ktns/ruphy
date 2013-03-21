require 'spec_helper'

describe RuPHY::Element do
  let(:element){described_class.new(0,:hoge,0)}

  let(:same_element){described_class.new(0,:hoge,0)}

  let(:other_element){described_class.new(0,:piyo,0)}

  subject{element}

  it do
    should == same_element
  end

  it do
    should be_eql same_element
  end

  it do
    should_not == other_element
  end

  it do
    should_not be_eql other_element
  end

  describe '#hash' do
    subject{element.hash}

    it do
      should == same_element.hash
    end

    it do
      should_not == other_element.hash
    end
  end

  context 'deserialized from YAML' do
    let(:original){RuPHY::Elements[42]}
    subject do
      YAML.load(original.to_yaml)
    end

    it {should == original}

    it {should be_eql original}

    its(:hash){should == original.hash}

    its(:m){should == original.m}
  end
end
