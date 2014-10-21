require 'spec_helper'

describe RuPHY::BasisSet::SimpleList do
  before do
    @basis_set = described_class.new(
      @spwf1=double(:spwf1), @spwf2=double(:spwf2))
  end

  subject {@basis_set}

  it {is_expected.to respond_to :each}

  it 'should enumerate basis functions' do
    expect(@spwf1).to receive :test
    expect(@spwf2).to receive :test
    subject.each do |b|
      b.test
    end
  end

  it '#map should return an array' do
    expect(subject.map do |b|
      b
    end).to be_instance_of Array
  end
end
