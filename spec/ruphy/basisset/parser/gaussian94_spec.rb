require File.join(File.dirname(__FILE__), %w|.. .. .. spec_helper.rb|)
require 'ruphy/basisset/parser/gaussian94'
require 'digest/md5'

describe RuPHY::BasisSet::Parser::Gaussian94 do
  describe '::ANGULAR_MOMENTA_ALL' do
    subject{described_class::ANGULAR_MOMENTA_ALL}

    its(:size){should be == 2**described_class::ANGULAR_MOMENTA.size - 1}
  end
  let(:sto3g_txt){<<EOF

!  STO-3G  EMSL  Basis Set Exchange Library   11/17/12 7:18 PM
! Elements                             References
! --------                             ----------
!  H - Ne: W.J. Hehre, R.F. Stewart and J.A. Pople, J. Chem. Phys. 2657 (1969).
! Na - Ar: W.J. Hehre, R. Ditchfield, R.F. Stewart, J.A. Pople,
!          J. Chem. Phys.  2769 (1970).
! K,Ca - : W.J. Pietro, B.A. Levy, W.J. Hehre and R.F. Stewart,
! Ga - Kr: J. Am. Chem. Soc. 19, 2225 (1980).
! Sc - Zn: W.J. Pietro and W.J. Hehre, J. Comp. Chem. 4, 241 (1983) + Gaussian.
!  Y - Cd: W.J. Pietro and W.J. Hehre, J. Comp. Chem. 4, 241 (1983). + Gaussian
!   


****
H     0 
S   3   1.00
      3.42525091             0.15432897       
      0.62391373             0.53532814       
      0.16885540             0.44463454       
****
He     0 
S   3   1.00
      6.36242139             0.15432897       
      1.15892300             0.53532814       
      0.31364979             0.44463454       
****
C     0 
S   3   1.00
     71.6168370              0.15432897       
     13.0450960              0.53532814       
      3.5305122              0.44463454       
SP   3   1.00
      2.9412494             -0.09996723             0.15591627       
      0.6834831              0.39951283             0.60768372       
      0.2222899              0.70011547             0.39195739       
****
Ti     0 
S   3   1.00
   1033.5712450              0.1543289673     
    188.2662926              0.5353281423     
     50.95220601             0.4446345422     
SP   3   1.00
     75.25120460            -0.0999672292           0.1559162750     
     17.48676162             0.3995128261           0.6076837186     
      5.687237606            0.7001154689           0.3919573931     
SP   3   1.00
      5.395535474           -0.2277635023           0.0049515112     
      1.645810296            0.2175436044           0.5777664691     
      0.635004777            0.9166769611           0.4846460366     
SP   3   1.00
      0.7122640246          -0.3088441215          -0.1215468600     
      0.2628702203           0.0196064117           0.5715227604     
      0.1160862609           1.1310344420           0.5498949471     
D   3   1.00
      1.645981194            0.2197679508     
      0.502076728            0.6555473627     
      0.193716810            0.2865732590     
****

EOF
  }

  describe 'STO-3G test string' do
    subject{Digest::MD5.digest(sto3g_txt)}

    it{should == "\x9F\x16,\xE5\xF0\xF1\xF6\xD8#\x9B\xC7\x11\x15\x8D\x9FX"}
  end

  describe '#parse' do
    before do
      @parser = described_class.new
      @parser.debug = ENV['RACC_DEBUG']
    end

    subject{ @parser.parse(str) }

    context 'with STO-3G' do
      let(:str){sto3g_txt}

      calling_it{should_not raise_error}

      it{should return_a RuPHY::BasisSet::Base}

      its(:elements){should include RuPHY::Elements[:H]}

      its(:elements){should include RuPHY::Elements[:He]}

      its(:elements){should include RuPHY::Elements[:C]}

      its(:elements){should include RuPHY::Elements[:Ti]}
    end

    context 'with empty string' do
      let(:str){''}

      calling_it{should raise_error}
    end
  end
end
