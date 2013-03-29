require 'yaml'
require 'ruphy/element'

module RuPHY
  module ElementData
    module PreDefined
      YAML = <<EOY
---
'1': &6631800 !ruby/struct:RuPHY::Element::Struct
  Z: 1
  sym: :H
  u: 1.00794
H: *6631800
1: *6631800
:H: *6631800
'2': &6631580 !ruby/struct:RuPHY::Element::Struct
  Z: 2
  sym: :He
  u: 4.002602
He: *6631580
2: *6631580
:He: *6631580
'3': &6631260 !ruby/struct:RuPHY::Element::Struct
  Z: 3
  sym: :Li
  u: 6.941
Li: *6631260
3: *6631260
:Li: *6631260
'4': &6631020 !ruby/struct:RuPHY::Element::Struct
  Z: 4
  sym: :Be
  u: 9.012182
Be: *6631020
4: *6631020
:Be: *6631020
'5': &6630760 !ruby/struct:RuPHY::Element::Struct
  Z: 5
  sym: :B
  u: 10.811
B: *6630760
5: *6630760
:B: *6630760
'6': &6630540 !ruby/struct:RuPHY::Element::Struct
  Z: 6
  sym: :C
  u: 12.0107
C: *6630540
6: *6630540
:C: *6630540
'7': &6630340 !ruby/struct:RuPHY::Element::Struct
  Z: 7
  sym: :N
  u: 14.0067
N: *6630340
7: *6630340
:N: *6630340
'8': &6630140 !ruby/struct:RuPHY::Element::Struct
  Z: 8
  sym: :O
  u: 15.9994
O: *6630140
8: *6630140
:O: *6630140
'9': &6629940 !ruby/struct:RuPHY::Element::Struct
  Z: 9
  sym: :F
  u: 18.9984032
F: *6629940
9: *6629940
:F: *6629940
'10': &6629720 !ruby/struct:RuPHY::Element::Struct
  Z: 10
  sym: :Ne
  u: 20.1797
Ne: *6629720
10: *6629720
:Ne: *6629720
'11': &6629500 !ruby/struct:RuPHY::Element::Struct
  Z: 11
  sym: :Na
  u: 22.98976928
Na: *6629500
11: *6629500
:Na: *6629500
'12': &6629260 !ruby/struct:RuPHY::Element::Struct
  Z: 12
  sym: :Mg
  u: 24.305
Mg: *6629260
12: *6629260
:Mg: *6629260
'13': &6629000 !ruby/struct:RuPHY::Element::Struct
  Z: 13
  sym: :Al
  u: 26.9815386
Al: *6629000
13: *6629000
:Al: *6629000
'14': &6628780 !ruby/struct:RuPHY::Element::Struct
  Z: 14
  sym: :Si
  u: 28.0855
Si: *6628780
14: *6628780
:Si: *6628780
'15': &6628460 !ruby/struct:RuPHY::Element::Struct
  Z: 15
  sym: :P
  u: 30.973762
P: *6628460
15: *6628460
:P: *6628460
'16': &6628140 !ruby/struct:RuPHY::Element::Struct
  Z: 16
  sym: :S
  u: 32.065
S: *6628140
16: *6628140
:S: *6628140
'17': &6627860 !ruby/struct:RuPHY::Element::Struct
  Z: 17
  sym: :Cl
  u: 35.453
Cl: *6627860
17: *6627860
:Cl: *6627860
'18': &6627600 !ruby/struct:RuPHY::Element::Struct
  Z: 18
  sym: :Ar
  u: 39.948
Ar: *6627600
18: *6627600
:Ar: *6627600
'19': &6627380 !ruby/struct:RuPHY::Element::Struct
  Z: 19
  sym: :K
  u: 39.0983
K: *6627380
19: *6627380
:K: *6627380
'20': &6627140 !ruby/struct:RuPHY::Element::Struct
  Z: 20
  sym: :Ca
  u: 40.078
Ca: *6627140
20: *6627140
:Ca: *6627140
'21': &6626900 !ruby/struct:RuPHY::Element::Struct
  Z: 21
  sym: :Sc
  u: 44.955912
Sc: *6626900
21: *6626900
:Sc: *6626900
'22': &6626580 !ruby/struct:RuPHY::Element::Struct
  Z: 22
  sym: :Ti
  u: 47.867
Ti: *6626580
22: *6626580
:Ti: *6626580
'23': &6626360 !ruby/struct:RuPHY::Element::Struct
  Z: 23
  sym: :V
  u: 50.9415
V: *6626360
23: *6626360
:V: *6626360
'24': &6523360 !ruby/struct:RuPHY::Element::Struct
  Z: 24
  sym: :Cr
  u: 51.9961
Cr: *6523360
24: *6523360
:Cr: *6523360
'25': &6523140 !ruby/struct:RuPHY::Element::Struct
  Z: 25
  sym: :Mn
  u: 54.938045
Mn: *6523140
25: *6523140
:Mn: *6523140
'26': &6522820 !ruby/struct:RuPHY::Element::Struct
  Z: 26
  sym: :Fe
  u: 55.845
Fe: *6522820
26: *6522820
:Fe: *6522820
'27': &6522580 !ruby/struct:RuPHY::Element::Struct
  Z: 27
  sym: :Co
  u: 58.933195
Co: *6522580
27: *6522580
:Co: *6522580
'28': &6522240 !ruby/struct:RuPHY::Element::Struct
  Z: 28
  sym: :Ni
  u: 58.6934
Ni: *6522240
28: *6522240
:Ni: *6522240
'29': &6521820 !ruby/struct:RuPHY::Element::Struct
  Z: 29
  sym: :Cu
  u: 63.546
Cu: *6521820
29: *6521820
:Cu: *6521820
'30': &6521600 !ruby/struct:RuPHY::Element::Struct
  Z: 30
  sym: :Zn
  u: 65.38
Zn: *6521600
30: *6521600
:Zn: *6521600
'31': &6521280 !ruby/struct:RuPHY::Element::Struct
  Z: 31
  sym: :Ga
  u: 69.723
Ga: *6521280
31: *6521280
:Ga: *6521280
'32': &6521040 !ruby/struct:RuPHY::Element::Struct
  Z: 32
  sym: :Ge
  u: 72.64
Ge: *6521040
32: *6521040
:Ge: *6521040
'33': &6520680 !ruby/struct:RuPHY::Element::Struct
  Z: 33
  sym: :As
  u: 74.9216
As: *6520680
33: *6520680
:As: *6520680
'34': &6520440 !ruby/struct:RuPHY::Element::Struct
  Z: 34
  sym: :Se
  u: 78.96
Se: *6520440
34: *6520440
:Se: *6520440
'35': &6520060 !ruby/struct:RuPHY::Element::Struct
  Z: 35
  sym: :Br
  u: 79.904
Br: *6520060
35: *6520060
:Br: *6520060
'36': &6519780 !ruby/struct:RuPHY::Element::Struct
  Z: 36
  sym: :Kr
  u: 83.798
Kr: *6519780
36: *6519780
:Kr: *6519780
'37': &6519520 !ruby/struct:RuPHY::Element::Struct
  Z: 37
  sym: :Rb
  u: 85.4678
Rb: *6519520
37: *6519520
:Rb: *6519520
'38': &6519240 !ruby/struct:RuPHY::Element::Struct
  Z: 38
  sym: :Sr
  u: 87.62
Sr: *6519240
38: *6519240
:Sr: *6519240
'39': &6518980 !ruby/struct:RuPHY::Element::Struct
  Z: 39
  sym: :Y
  u: 88.90585
Y: *6518980
39: *6518980
:Y: *6518980
'40': &6518720 !ruby/struct:RuPHY::Element::Struct
  Z: 40
  sym: :Zr
  u: 91.224
Zr: *6518720
40: *6518720
:Zr: *6518720
'41': &6518440 !ruby/struct:RuPHY::Element::Struct
  Z: 41
  sym: :Nb
  u: 92.90638
Nb: *6518440
41: *6518440
:Nb: *6518440
'42': &6518020 !ruby/struct:RuPHY::Element::Struct
  Z: 42
  sym: :Mo
  u: 95.96
Mo: *6518020
42: *6518020
:Mo: *6518020
'43': &6517800 !ruby/struct:RuPHY::Element::Struct
  Z: 43
  sym: :Tc
  u: 0.0
Tc: *6517800
43: *6517800
:Tc: *6517800
'44': &6517480 !ruby/struct:RuPHY::Element::Struct
  Z: 44
  sym: :Ru
  u: 101.07
Ru: *6517480
44: *6517480
:Ru: *6517480
'45': &6517280 !ruby/struct:RuPHY::Element::Struct
  Z: 45
  sym: :Rh
  u: 102.9055
Rh: *6517280
45: *6517280
:Rh: *6517280
'46': &6516900 !ruby/struct:RuPHY::Element::Struct
  Z: 46
  sym: :Pd
  u: 106.42
Pd: *6516900
46: *6516900
:Pd: *6516900
'47': &6516660 !ruby/struct:RuPHY::Element::Struct
  Z: 47
  sym: :Ag
  u: 107.8682
Ag: *6516660
47: *6516660
:Ag: *6516660
'48': &6516320 !ruby/struct:RuPHY::Element::Struct
  Z: 48
  sym: :Cd
  u: 112.411
Cd: *6516320
48: *6516320
:Cd: *6516320
'49': &6516040 !ruby/struct:RuPHY::Element::Struct
  Z: 49
  sym: :In
  u: 114.818
In: *6516040
49: *6516040
:In: *6516040
'50': &6515700 !ruby/struct:RuPHY::Element::Struct
  Z: 50
  sym: :Sn
  u: 118.71
Sn: *6515700
50: *6515700
:Sn: *6515700
'51': &6487400 !ruby/struct:RuPHY::Element::Struct
  Z: 51
  sym: :Sb
  u: 121.76
Sb: *6487400
51: *6487400
:Sb: *6487400
'52': &6487160 !ruby/struct:RuPHY::Element::Struct
  Z: 52
  sym: :Te
  u: 127.6
Te: *6487160
52: *6487160
:Te: *6487160
'53': &6486800 !ruby/struct:RuPHY::Element::Struct
  Z: 53
  sym: :I
  u: 126.90447
I: *6486800
53: *6486800
:I: *6486800
'54': &6486340 !ruby/struct:RuPHY::Element::Struct
  Z: 54
  sym: :Xe
  u: 131.293
Xe: *6486340
54: *6486340
:Xe: *6486340
'55': &6486140 !ruby/struct:RuPHY::Element::Struct
  Z: 55
  sym: :Cs
  u: 132.9054519
Cs: *6486140
55: *6486140
:Cs: *6486140
'56': &6485660 !ruby/struct:RuPHY::Element::Struct
  Z: 56
  sym: :Ba
  u: 137.327
Ba: *6485660
56: *6485660
:Ba: *6485660
'57': &6485360 !ruby/struct:RuPHY::Element::Struct
  Z: 57
  sym: :La
  u: 138.90547
La: *6485360
57: *6485360
:La: *6485360
'58': &6484880 !ruby/struct:RuPHY::Element::Struct
  Z: 58
  sym: :Ce
  u: 140.116
Ce: *6484880
58: *6484880
:Ce: *6484880
'59': &6484540 !ruby/struct:RuPHY::Element::Struct
  Z: 59
  sym: :Pr
  u: 140.90765
Pr: *6484540
59: *6484540
:Pr: *6484540
'60': &6484180 !ruby/struct:RuPHY::Element::Struct
  Z: 60
  sym: :Nd
  u: 144.242
Nd: *6484180
60: *6484180
:Nd: *6484180
'61': &6483820 !ruby/struct:RuPHY::Element::Struct
  Z: 61
  sym: :Pm
  u: 0.0
Pm: *6483820
61: *6483820
:Pm: *6483820
'62': &6483460 !ruby/struct:RuPHY::Element::Struct
  Z: 62
  sym: :Sm
  u: 150.36
Sm: *6483460
62: *6483460
:Sm: *6483460
'63': &6483080 !ruby/struct:RuPHY::Element::Struct
  Z: 63
  sym: :Eu
  u: 151.964
Eu: *6483080
63: *6483080
:Eu: *6483080
'64': &6482440 !ruby/struct:RuPHY::Element::Struct
  Z: 64
  sym: :Gd
  u: 157.25
Gd: *6482440
64: *6482440
:Gd: *6482440
'65': &6482000 !ruby/struct:RuPHY::Element::Struct
  Z: 65
  sym: :Tb
  u: 158.92535
Tb: *6482000
65: *6482000
:Tb: *6482000
'66': &6481440 !ruby/struct:RuPHY::Element::Struct
  Z: 66
  sym: :Dy
  u: 162.5
Dy: *6481440
66: *6481440
:Dy: *6481440
'67': &6481120 !ruby/struct:RuPHY::Element::Struct
  Z: 67
  sym: :Ho
  u: 164.93032
Ho: *6481120
67: *6481120
:Ho: *6481120
'68': &6480660 !ruby/struct:RuPHY::Element::Struct
  Z: 68
  sym: :Er
  u: 167.259
Er: *6480660
68: *6480660
:Er: *6480660
'69': &6480280 !ruby/struct:RuPHY::Element::Struct
  Z: 69
  sym: :Tm
  u: 168.93421
Tm: *6480280
69: *6480280
:Tm: *6480280
'70': &6479680 !ruby/struct:RuPHY::Element::Struct
  Z: 70
  sym: :Yb
  u: 173.054
Yb: *6479680
70: *6479680
:Yb: *6479680
'71': &6479480 !ruby/struct:RuPHY::Element::Struct
  Z: 71
  sym: :Lu
  u: 174.9668
Lu: *6479480
71: *6479480
:Lu: *6479480
'72': &6453480 !ruby/struct:RuPHY::Element::Struct
  Z: 72
  sym: :Hf
  u: 178.49
Hf: *6453480
72: *6453480
:Hf: *6453480
'73': &6453220 !ruby/struct:RuPHY::Element::Struct
  Z: 73
  sym: :Ta
  u: 180.94788
Ta: *6453220
73: *6453220
:Ta: *6453220
'74': &6452860 !ruby/struct:RuPHY::Element::Struct
  Z: 74
  sym: :W
  u: 183.84
W: *6452860
74: *6452860
:W: *6452860
'75': &6452660 !ruby/struct:RuPHY::Element::Struct
  Z: 75
  sym: :Re
  u: 186.207
Re: *6452660
75: *6452660
:Re: *6452660
'76': &6452060 !ruby/struct:RuPHY::Element::Struct
  Z: 76
  sym: :Os
  u: 190.23
Os: *6452060
76: *6452060
:Os: *6452060
'77': &6451800 !ruby/struct:RuPHY::Element::Struct
  Z: 77
  sym: :Ir
  u: 192.217
Ir: *6451800
77: *6451800
:Ir: *6451800
'78': &6451580 !ruby/struct:RuPHY::Element::Struct
  Z: 78
  sym: :Pt
  u: 195.084
Pt: *6451580
78: *6451580
:Pt: *6451580
'79': &6451200 !ruby/struct:RuPHY::Element::Struct
  Z: 79
  sym: :Au
  u: 196.966569
Au: *6451200
79: *6451200
:Au: *6451200
'80': &6450940 !ruby/struct:RuPHY::Element::Struct
  Z: 80
  sym: :Hg
  u: 200.59
Hg: *6450940
80: *6450940
:Hg: *6450940
'81': &6450580 !ruby/struct:RuPHY::Element::Struct
  Z: 81
  sym: :Tl
  u: 204.3833
Tl: *6450580
81: *6450580
:Tl: *6450580
'82': &6450320 !ruby/struct:RuPHY::Element::Struct
  Z: 82
  sym: :Pb
  u: 207.2
Pb: *6450320
82: *6450320
:Pb: *6450320
'83': &6449760 !ruby/struct:RuPHY::Element::Struct
  Z: 83
  sym: :Bi
  u: 208.9804
Bi: *6449760
83: *6449760
:Bi: *6449760
'84': &6449480 !ruby/struct:RuPHY::Element::Struct
  Z: 84
  sym: :Po
  u: 0.0
Po: *6449480
84: *6449480
:Po: *6449480
'85': &6449180 !ruby/struct:RuPHY::Element::Struct
  Z: 85
  sym: :At
  u: 0.0
At: *6449180
85: *6449180
:At: *6449180
'86': &6448880 !ruby/struct:RuPHY::Element::Struct
  Z: 86
  sym: :Rn
  u: 0.0
Rn: *6448880
86: *6448880
:Rn: *6448880
'87': &6448680 !ruby/struct:RuPHY::Element::Struct
  Z: 87
  sym: :Fr
  u: 0.0
Fr: *6448680
87: *6448680
:Fr: *6448680
'88': &6448280 !ruby/struct:RuPHY::Element::Struct
  Z: 88
  sym: :Ra
  u: 0.0
Ra: *6448280
88: *6448280
:Ra: *6448280
'89': &6447940 !ruby/struct:RuPHY::Element::Struct
  Z: 89
  sym: :Ac
  u: 0.0
Ac: *6447940
89: *6447940
:Ac: *6447940
'90': &6447560 !ruby/struct:RuPHY::Element::Struct
  Z: 90
  sym: :Th
  u: 232.03806
Th: *6447560
90: *6447560
:Th: *6447560
'91': &6447300 !ruby/struct:RuPHY::Element::Struct
  Z: 91
  sym: :Pa
  u: 231.03588
Pa: *6447300
91: *6447300
:Pa: *6447300
'92': &6446920 !ruby/struct:RuPHY::Element::Struct
  Z: 92
  sym: :U
  u: 238.02891
U: *6446920
92: *6446920
:U: *6446920
'93': &6446700 !ruby/struct:RuPHY::Element::Struct
  Z: 93
  sym: :Np
  u: 0.0
Np: *6446700
93: *6446700
:Np: *6446700
'94': &6446300 !ruby/struct:RuPHY::Element::Struct
  Z: 94
  sym: :Pu
  u: 0.0
Pu: *6446300
94: *6446300
:Pu: *6446300
'95': &6445980 !ruby/struct:RuPHY::Element::Struct
  Z: 95
  sym: :Am
  u: 0.0
Am: *6445980
95: *6445980
:Am: *6445980
'96': &6445700 !ruby/struct:RuPHY::Element::Struct
  Z: 96
  sym: :Cm
  u: 0.0
Cm: *6445700
96: *6445700
:Cm: *6445700
'97': &6169540 !ruby/struct:RuPHY::Element::Struct
  Z: 97
  sym: :Bk
  u: 0.0
Bk: *6169540
97: *6169540
:Bk: *6169540
'98': &6169200 !ruby/struct:RuPHY::Element::Struct
  Z: 98
  sym: :Cf
  u: 0.0
Cf: *6169200
98: *6169200
:Cf: *6169200
'99': &6168740 !ruby/struct:RuPHY::Element::Struct
  Z: 99
  sym: :Es
  u: 0.0
Es: *6168740
99: *6168740
:Es: *6168740
'100': &6168440 !ruby/struct:RuPHY::Element::Struct
  Z: 100
  sym: :Fm
  u: 0.0
Fm: *6168440
100: *6168440
:Fm: *6168440
'101': &6165480 !ruby/struct:RuPHY::Element::Struct
  Z: 101
  sym: :Md
  u: 0.0
Md: *6165480
101: *6165480
:Md: *6165480
'102': &6162380 !ruby/struct:RuPHY::Element::Struct
  Z: 102
  sym: :No
  u: 0.0
'No': *6162380
102: *6162380
:No: *6162380
'103': &6141940 !ruby/struct:RuPHY::Element::Struct
  Z: 103
  sym: :Lr
  u: 0.0
Lr: *6141940
103: *6141940
:Lr: *6141940
'104': &6141360 !ruby/struct:RuPHY::Element::Struct
  Z: 104
  sym: :Rf
  u: 0.0
Rf: *6141360
104: *6141360
:Rf: *6141360
'105': &6140880 !ruby/struct:RuPHY::Element::Struct
  Z: 105
  sym: :Db
  u: 0.0
Db: *6140880
105: *6140880
:Db: *6140880
'106': &6140620 !ruby/struct:RuPHY::Element::Struct
  Z: 106
  sym: :Sg
  u: 0.0
Sg: *6140620
106: *6140620
:Sg: *6140620
'107': &6139900 !ruby/struct:RuPHY::Element::Struct
  Z: 107
  sym: :Bh
  u: 0.0
Bh: *6139900
107: *6139900
:Bh: *6139900
'108': &6139000 !ruby/struct:RuPHY::Element::Struct
  Z: 108
  sym: :Hs
  u: 0.0
Hs: *6139000
108: *6139000
:Hs: *6139000
'109': &6138580 !ruby/struct:RuPHY::Element::Struct
  Z: 109
  sym: :Mt
  u: 0.0
Mt: *6138580
109: *6138580
:Mt: *6138580
'110': &6137580 !ruby/struct:RuPHY::Element::Struct
  Z: 110
  sym: :Ds
  u: 0.0
Ds: *6137580
110: *6137580
:Ds: *6137580
'111': &6137080 !ruby/struct:RuPHY::Element::Struct
  Z: 111
  sym: :Rg
  u: 0.0
Rg: *6137080
111: *6137080
:Rg: *6137080
'112': &6136120 !ruby/struct:RuPHY::Element::Struct
  Z: 112
  sym: :Cn
  u: 0.0
Cn: *6136120
112: *6136120
:Cn: *6136120
'113': &6129240 !ruby/struct:RuPHY::Element::Struct
  Z: 113
  sym: :Uut
  u: 0.0
Uut: *6129240
113: *6129240
:Uut: *6129240
'114': &6126820 !ruby/struct:RuPHY::Element::Struct
  Z: 114
  sym: :Uuq
  u: 0.0
Uuq: *6126820
114: *6126820
:Uuq: *6126820
'115': &6126400 !ruby/struct:RuPHY::Element::Struct
  Z: 115
  sym: :Uup
  u: 0.0
Uup: *6126400
115: *6126400
:Uup: *6126400
'116': &6126160 !ruby/struct:RuPHY::Element::Struct
  Z: 116
  sym: :Uuh
  u: 0.0
Uuh: *6126160
116: *6126160
:Uuh: *6126160
'117': &6125800 !ruby/struct:RuPHY::Element::Struct
  Z: 117
  sym: :Uus
  u: 0.0
Uus: *6125800
117: *6125800
:Uus: *6125800
'118': &6124940 !ruby/struct:RuPHY::Element::Struct
  Z: 118
  sym: :Uuo
  u: 0.0
Uuo: *6124940
118: *6124940
:Uuo: *6124940
EOY
      Hash = ::YAML.load(YAML)

      private
      def get_elem_data key
        return Hash[key]
      end

      def get_all_data
        Hash.values.uniq.each do |data|
          yield data
        end
      end
    end
  end
end
