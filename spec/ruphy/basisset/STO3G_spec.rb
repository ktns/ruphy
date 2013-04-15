require 'spec_helper'
require 'ruphy/basisset/STO3G'

describe "RuPHY::BasisSet::STO3G" do
  subject{RuPHY::BasisSet::STO3G}

  it{should be_kind_of RuPHY::BasisSet::LCAO::Gaussian}

  it{should be_frozen}

  it{pending{should respond_to :shells}}
end
