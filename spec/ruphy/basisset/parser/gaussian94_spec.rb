require File.join(File.dirname(__FILE__), %w|.. .. .. spec_helper.rb|)
require 'ruphy/basisset/parser/gaussian94'

describe RuPHY::BasisSet::Parser::Gaussian94 do
	let(:sto3g_txt){<<EOF
!  STO-3G  EMSL  Basis Set Exchange Library   10/25/12 9:43 AM
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

EOF
	}
	describe '#parse' do
		subject{ lambda { described_class.new.parse(str) } }

		context 'with STO-3G' do
			let(:str){sto3g_txt}

			it{should_not raise_error}
		end

		context 'with empty string' do
			let(:str){''}

			it{should raise_error}
		end
	end
end
