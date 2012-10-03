require 'yaml'
require 'ruphy/element'

module RuPHY
	module ElementData
		module PreDefined
			YAML = <<EOY
---
"1": &id001 !ruby/object:RuPHY::Element
  Z: 1
  m: 1837.3622794466407
  sym: :H
H: *id001
1: *id001
:H: *id001
"2": &id002 !ruby/object:RuPHY::Element
  Z: 2
  m: 7296.297333608829
  sym: :He
He: *id002
2: *id002
:He: *id002
"3": &id003 !ruby/object:RuPHY::Element
  Z: 3
  m: 12652.669386708665
  sym: :Li
Li: *id003
3: *id003
:Li: *id003
"4": &id004 !ruby/object:RuPHY::Element
  Z: 4
  m: 16428.20332788458
  sym: :Be
Be: *id004
4: *id004
:Be: *id004
"5": &id005 !ruby/object:RuPHY::Element
  Z: 5
  m: 19707.248053552426
  sym: :B
B: *id005
5: *id005
:B: *id005
"6": &id006 !ruby/object:RuPHY::Element
  Z: 6
  m: 21894.16744027399
  sym: :C
C: *id006
6: *id006
:C: *id006
"7": &id007 !ruby/object:RuPHY::Element
  Z: 7
  m: 25532.65297490452
  sym: :N
N: *id007
7: *id007
:N: *id007
"8": &id008 !ruby/object:RuPHY::Element
  Z: 8
  m: 29165.122977338513
  sym: :O
O: *id008
8: *id008
:O: *id008
"9": &id009 !ruby/object:RuPHY::Element
  Z: 9
  m: 34631.971555249664
  sym: :F
F: *id009
9: *id009
:F: *id009
"10": &id010 !ruby/object:RuPHY::Element
  Z: 10
  m: 36785.34395951086
  sym: :Ne
Ne: *id010
10: *id010
:Ne: *id010
"11": &id011 !ruby/object:RuPHY::Element
  Z: 11
  m: 41907.78705900466
  sym: :Na
Na: *id011
11: *id011
:Na: *id011
"12": &id012 !ruby/object:RuPHY::Element
  Z: 12
  m: 44305.306071740975
  sym: :Mg
Mg: *id012
12: *id012
:Mg: *id012
"13": &id013 !ruby/object:RuPHY::Element
  Z: 13
  m: 49184.33762433629
  sym: :Al
Al: *id013
13: *id013
:Al: *id013
"14": &id014 !ruby/object:RuPHY::Element
  Z: 14
  m: 51196.73621386057
  sym: :Si
Si: *id014
14: *id014
:Si: *id014
"15": &id015 !ruby/object:RuPHY::Element
  Z: 15
  m: 56461.71592689817
  sym: :P
P: *id015
15: *id015
:P: *id015
"16": &id016 !ruby/object:RuPHY::Element
  Z: 16
  m: 58450.92117631657
  sym: :S
S: *id016
16: *id016
:S: *id016
"17": &id017 !ruby/object:RuPHY::Element
  Z: 17
  m: 64626.86756475758
  sym: :Cl
Cl: *id017
17: *id017
:Cl: *id017
"18": &id018 !ruby/object:RuPHY::Element
  Z: 18
  m: 72820.75157185388
  sym: :Ar
Ar: *id018
18: *id018
:Ar: *id018
"19": &id019 !ruby/object:RuPHY::Element
  Z: 19
  m: 71271.84317567374
  sym: :K
K: *id019
19: *id019
:K: *id019
"20": &id020 !ruby/object:RuPHY::Element
  Z: 20
  m: 73057.72708262641
  sym: :Ca
Ca: *id020
20: *id020
:Ca: *id020
"21": &id021 !ruby/object:RuPHY::Element
  Z: 21
  m: 81949.61698803757
  sym: :Sc
Sc: *id021
21: *id021
:Sc: *id021
"22": &id022 !ruby/object:RuPHY::Element
  Z: 22
  m: 87256.20595498972
  sym: :Ti
Ti: *id022
22: *id022
:Ti: *id022
"23": &id023 !ruby/object:RuPHY::Element
  Z: 23
  m: 92860.67678476004
  sym: :V
V: *id023
23: *id023
:V: *id023
"24": &id024 !ruby/object:RuPHY::Element
  Z: 24
  m: 94783.09504368858
  sym: :Cr
Cr: *id024
24: *id024
:Cr: *id024
"25": &id025 !ruby/object:RuPHY::Element
  Z: 25
  m: 100145.93288245542
  sym: :Mn
Mn: *id025
25: *id025
:Mn: *id025
"26": &id026 !ruby/object:RuPHY::Element
  Z: 26
  m: 101799.21076224542
  sym: :Fe
Fe: *id026
26: *id026
:Fe: *id026
"27": &id027 !ruby/object:RuPHY::Element
  Z: 27
  m: 107428.64605063135
  sym: :Co
Co: *id027
27: *id027
:Co: *id027
"28": &id028 !ruby/object:RuPHY::Element
  Z: 28
  m: 106991.52649212597
  sym: :Ni
Ni: *id028
28: *id028
:Ni: *id028
"29": &id029 !ruby/object:RuPHY::Element
  Z: 29
  m: 115837.27544270117
  sym: :Cu
Cu: *id029
29: *id029
:Cu: *id029
"30": &id030 !ruby/object:RuPHY::Element
  Z: 30
  m: 119180.45303313824
  sym: :Zn
Zn: *id030
30: *id030
:Zn: *id030
"31": &id031 !ruby/object:RuPHY::Element
  Z: 31
  m: 127097.25798148513
  sym: :Ga
Ga: *id031
31: *id031
:Ga: *id031
"32": &id032 !ruby/object:RuPHY::Element
  Z: 32
  m: 132414.62386551182
  sym: :Ge
Ge: *id032
32: *id032
:Ge: *id032
"33": &id033 !ruby/object:RuPHY::Element
  Z: 33
  m: 136573.72636842413
  sym: :As
As: *id033
33: *id033
:As: *id033
"34": &id034 !ruby/object:RuPHY::Element
  Z: 34
  m: 143935.27946614553
  sym: :Se
Se: *id034
34: *id034
:Se: *id034
"35": &id035 !ruby/object:RuPHY::Element
  Z: 35
  m: 145656.086252063
  sym: :Br
Br: *id035
35: *id035
:Br: *id035
"36": &id036 !ruby/object:RuPHY::Element
  Z: 36
  m: 152754.41424397245
  sym: :Kr
Kr: *id036
36: *id036
:Kr: *id036
"37": &id037 !ruby/object:RuPHY::Element
  Z: 37
  m: 155798.27353541835
  sym: :Rb
Rb: *id037
37: *id037
:Rb: *id037
"38": &id038 !ruby/object:RuPHY::Element
  Z: 38
  m: 159721.49426068482
  sym: :Sr
Sr: *id038
38: *id038
:Sr: *id038
"39": &id039 !ruby/object:RuPHY::Element
  Z: 39
  m: 162065.4554955068
  sym: :Y
Y: *id039
39: *id039
:Y: *id039
"40": &id040 !ruby/object:RuPHY::Element
  Z: 40
  m: 166291.1845747171
  sym: :Zr
Zr: *id040
40: *id040
:Zr: *id040
"41": &id041 !ruby/object:RuPHY::Element
  Z: 41
  m: 169357.97580405162
  sym: :Nb
Nb: *id041
41: *id041
:Nb: *id041
"42": &id042 !ruby/object:RuPHY::Element
  Z: 42
  m: 174924.38472101477
  sym: :Mo
Mo: *id042
42: *id042
:Mo: *id042
"43": &id043 !ruby/object:RuPHY::Element
  Z: 43
  m: 0.0
  sym: :Tc
Tc: *id043
43: *id043
:Tc: *id043
"44": &id044 !ruby/object:RuPHY::Element
  Z: 44
  m: 184239.34518291958
  sym: :Ru
Ru: *id044
44: *id044
:Ru: *id044
"45": &id045 !ruby/object:RuPHY::Element
  Z: 45
  m: 187585.25710617326
  sym: :Rh
Rh: *id045
45: *id045
:Rh: *id045
"46": &id046 !ruby/object:RuPHY::Element
  Z: 46
  m: 193991.79889548136
  sym: :Pd
Pd: *id046
46: *id046
:Pd: *id046
"47": &id047 !ruby/object:RuPHY::Element
  Z: 47
  m: 196631.70608548736
  sym: :Ag
Ag: *id047
47: *id047
:Ag: *id047
"48": &id048 !ruby/object:RuPHY::Element
  Z: 48
  m: 204912.72416500616
  sym: :Cd
Cd: *id048
48: *id048
:Cd: *id048
"49": &id049 !ruby/object:RuPHY::Element
  Z: 49
  m: 209300.41689138676
  sym: :In
In: *id049
49: *id049
:In: *id049
"50": &id050 !ruby/object:RuPHY::Element
  Z: 50
  m: 216395.0991062074
  sym: :Sn
Sn: *id050
50: *id050
:Sn: *id050
"51": &id051 !ruby/object:RuPHY::Element
  Z: 51
  m: 221954.90916663985
  sym: :Sb
Sb: *id051
51: *id051
:Sb: *id051
"52": &id052 !ruby/object:RuPHY::Element
  Z: 52
  m: 232600.5782659596
  sym: :Te
Te: *id052
52: *id052
:Te: *id052
"53": &id053 !ruby/object:RuPHY::Element
  Z: 53
  m: 231332.70459667026
  sym: :I
I: *id053
53: *id053
:I: *id053
"54": &id054 !ruby/object:RuPHY::Element
  Z: 54
  m: 239332.50566044386
  sym: :Xe
Xe: *id054
54: *id054
:Xe: *id054
"55": &id055 !ruby/object:RuPHY::Element
  Z: 55
  m: 242271.82575735645
  sym: :Cs
Cs: *id055
55: *id055
:Cs: *id055
"56": &id056 !ruby/object:RuPHY::Element
  Z: 56
  m: 250331.81513737803
  sym: :Ba
Ba: *id056
56: *id056
:Ba: *id056
"57": &id057 !ruby/object:RuPHY::Element
  Z: 57
  m: 253209.19001806356
  sym: :La
La: *id057
57: *id057
:La: *id057
"58": &id058 !ruby/object:RuPHY::Element
  Z: 58
  m: 255415.85128772102
  sym: :Ce
Ce: *id058
58: *id058
:Ce: *id058
"59": &id059 !ruby/object:RuPHY::Element
  Z: 59
  m: 256858.94100389845
  sym: :Pr
Pr: *id059
59: *id059
:Pr: *id059
"60": &id060 !ruby/object:RuPHY::Element
  Z: 60
  m: 262937.0894219322
  sym: :Nd
Nd: *id060
60: *id060
:Nd: *id060
"61": &id061 !ruby/object:RuPHY::Element
  Z: 61
  m: 0.0
  sym: :Pm
Pm: *id061
61: *id061
:Pm: *id061
"62": &id062 !ruby/object:RuPHY::Element
  Z: 62
  m: 274089.52153659635
  sym: :Sm
Sm: *id062
62: *id062
:Sm: *id062
"63": &id063 !ruby/object:RuPHY::Element
  Z: 63
  m: 277013.4347618204
  sym: :Eu
Eu: *id063
63: *id063
:Eu: *id063
"64": &id064 !ruby/object:RuPHY::Element
  Z: 64
  m: 286649.22360754036
  sym: :Gd
Gd: *id064
64: *id064
:Gd: *id064
"65": &id065 !ruby/object:RuPHY::Element
  Z: 65
  m: 289703.19993040775
  sym: :Tb
Tb: *id065
65: *id065
:Tb: *id065
"66": &id066 !ruby/object:RuPHY::Element
  Z: 66
  m: 296219.38846566173
  sym: :Dy
Dy: *id066
66: *id066
:Dy: *id066
"67": &id067 !ruby/object:RuPHY::Element
  Z: 67
  m: 300649.59095289785
  sym: :Ho
Ho: *id067
67: *id067
:Ho: *id067
"68": &id068 !ruby/object:RuPHY::Element
  Z: 68
  m: 304894.5150484807
  sym: :Er
Er: *id068
68: *id068
:Er: *id068
"69": &id069 !ruby/object:RuPHY::Element
  Z: 69
  m: 307948.2361669519
  sym: :Tm
Tm: *id069
69: *id069
:Tm: *id069
"70": &id070 !ruby/object:RuPHY::Element
  Z: 70
  m: 315458.15416330233
  sym: :Yb
Yb: *id070
70: *id070
:Yb: *id070
"71": &id071 !ruby/object:RuPHY::Element
  Z: 71
  m: 318944.9753710384
  sym: :Lu
Lu: *id071
71: *id071
:Lu: *id071
"72": &id072 !ruby/object:RuPHY::Element
  Z: 72
  m: 325367.3762906829
  sym: :Hf
Hf: *id072
72: *id072
:Hf: *id072
"73": &id073 !ruby/object:RuPHY::Element
  Z: 73
  m: 329847.81758620276
  sym: :Ta
Ta: *id073
73: *id073
:Ta: *id073
"74": &id074 !ruby/object:RuPHY::Element
  Z: 74
  m: 335119.8300032446
  sym: :W
W: *id074
74: *id074
:W: *id074
"75": &id075 !ruby/object:RuPHY::Element
  Z: 75
  m: 339434.60718784906
  sym: :Re
Re: *id075
75: *id075
:Re: *id075
"76": &id076 !ruby/object:RuPHY::Element
  Z: 76
  m: 346768.08780198666
  sym: :Os
Os: *id076
76: *id076
:Os: *id076
"77": &id077 !ruby/object:RuPHY::Element
  Z: 77
  m: 350390.16733971756
  sym: :Ir
Ir: *id077
77: *id077
:Ir: *id077
"78": &id078 !ruby/object:RuPHY::Element
  Z: 78
  m: 355616.388796524
  sym: :Pt
Pt: *id078
78: *id078
:Pt: *id078
"79": &id079 !ruby/object:RuPHY::Element
  Z: 79
  m: 359048.10226067423
  sym: :Au
Au: *id079
79: *id079
:Au: *id079
"80": &id080 !ruby/object:RuPHY::Element
  Z: 80
  m: 365653.21312201285
  sym: :Hg
Hg: *id080
80: *id080
:Hg: *id080
"81": &id081 !ruby/object:RuPHY::Element
  Z: 81
  m: 372567.9762375008
  sym: :Tl
Tl: *id081
81: *id081
:Tl: *id081
"82": &id082 !ruby/object:RuPHY::Element
  Z: 82
  m: 377702.50640052377
  sym: :Pb
Pb: *id082
82: *id082
:Pb: *id082
"83": &id083 !ruby/object:RuPHY::Element
  Z: 83
  m: 380947.9771649808
  sym: :Bi
Bi: *id083
83: *id083
:Bi: *id083
"84": &id084 !ruby/object:RuPHY::Element
  Z: 84
  m: 0.0
  sym: :Po
Po: *id084
84: *id084
:Po: *id084
"85": &id085 !ruby/object:RuPHY::Element
  Z: 85
  m: 0.0
  sym: :At
At: *id085
85: *id085
:At: *id085
"86": &id086 !ruby/object:RuPHY::Element
  Z: 86
  m: 0.0
  sym: :Rn
Rn: *id086
86: *id086
:Rn: *id086
"87": &id087 !ruby/object:RuPHY::Element
  Z: 87
  m: 0.0
  sym: :Fr
Fr: *id087
87: *id087
:Fr: *id087
"88": &id088 !ruby/object:RuPHY::Element
  Z: 88
  m: 0.0
  sym: :Ra
Ra: *id088
88: *id088
:Ra: *id088
"89": &id089 !ruby/object:RuPHY::Element
  Z: 89
  m: 0.0
  sym: :Ac
Ac: *id089
89: *id089
:Ac: *id089
"90": &id090 !ruby/object:RuPHY::Element
  Z: 90
  m: 422979.5214397448
  sym: :Th
Th: *id090
90: *id090
:Th: *id090
"91": &id091 !ruby/object:RuPHY::Element
  Z: 91
  m: 421152.6589983139
  sym: :Pa
Pa: *id091
91: *id091
:Pa: *id091
"92": &id092 !ruby/object:RuPHY::Element
  Z: 92
  m: 433900.1732759879
  sym: :U
U: *id092
92: *id092
:U: *id092
"93": &id093 !ruby/object:RuPHY::Element
  Z: 93
  m: 0.0
  sym: :Np
Np: *id093
93: *id093
:Np: *id093
"94": &id094 !ruby/object:RuPHY::Element
  Z: 94
  m: 0.0
  sym: :Pu
Pu: *id094
94: *id094
:Pu: *id094
"95": &id095 !ruby/object:RuPHY::Element
  Z: 95
  m: 0.0
  sym: :Am
Am: *id095
95: *id095
:Am: *id095
"96": &id096 !ruby/object:RuPHY::Element
  Z: 96
  m: 0.0
  sym: :Cm
Cm: *id096
96: *id096
:Cm: *id096
"97": &id097 !ruby/object:RuPHY::Element
  Z: 97
  m: 0.0
  sym: :Bk
Bk: *id097
97: *id097
:Bk: *id097
"98": &id098 !ruby/object:RuPHY::Element
  Z: 98
  m: 0.0
  sym: :Cf
Cf: *id098
98: *id098
:Cf: *id098
"99": &id099 !ruby/object:RuPHY::Element
  Z: 99
  m: 0.0
  sym: :Es
Es: *id099
99: *id099
:Es: *id099
"100": &id100 !ruby/object:RuPHY::Element
  Z: 100
  m: 0.0
  sym: :Fm
Fm: *id100
100: *id100
:Fm: *id100
"101": &id101 !ruby/object:RuPHY::Element
  Z: 101
  m: 0.0
  sym: :Md
Md: *id101
101: *id101
:Md: *id101
"102": &id102 !ruby/object:RuPHY::Element
  Z: 102
  m: 0.0
  sym: :No
"No": *id102
102: *id102
:No: *id102
"103": &id103 !ruby/object:RuPHY::Element
  Z: 103
  m: 0.0
  sym: :Lr
Lr: *id103
103: *id103
:Lr: *id103
"104": &id104 !ruby/object:RuPHY::Element
  Z: 104
  m: 0.0
  sym: :Rf
Rf: *id104
104: *id104
:Rf: *id104
"105": &id105 !ruby/object:RuPHY::Element
  Z: 105
  m: 0.0
  sym: :Db
Db: *id105
105: *id105
:Db: *id105
"106": &id106 !ruby/object:RuPHY::Element
  Z: 106
  m: 0.0
  sym: :Sg
Sg: *id106
106: *id106
:Sg: *id106
"107": &id107 !ruby/object:RuPHY::Element
  Z: 107
  m: 0.0
  sym: :Bh
Bh: *id107
107: *id107
:Bh: *id107
"108": &id108 !ruby/object:RuPHY::Element
  Z: 108
  m: 0.0
  sym: :Hs
Hs: *id108
108: *id108
:Hs: *id108
"109": &id109 !ruby/object:RuPHY::Element
  Z: 109
  m: 0.0
  sym: :Mt
Mt: *id109
109: *id109
:Mt: *id109
"110": &id110 !ruby/object:RuPHY::Element
  Z: 110
  m: 0.0
  sym: :Ds
Ds: *id110
110: *id110
:Ds: *id110
"111": &id111 !ruby/object:RuPHY::Element
  Z: 111
  m: 0.0
  sym: :Rg
Rg: *id111
111: *id111
:Rg: *id111
"112": &id112 !ruby/object:RuPHY::Element
  Z: 112
  m: 0.0
  sym: :Cn
Cn: *id112
112: *id112
:Cn: *id112
"113": &id113 !ruby/object:RuPHY::Element
  Z: 113
  m: 0.0
  sym: :Uut
Uut: *id113
113: *id113
:Uut: *id113
"114": &id114 !ruby/object:RuPHY::Element
  Z: 114
  m: 0.0
  sym: :Uuq
Uuq: *id114
114: *id114
:Uuq: *id114
"115": &id115 !ruby/object:RuPHY::Element
  Z: 115
  m: 0.0
  sym: :Uup
Uup: *id115
115: *id115
:Uup: *id115
"116": &id116 !ruby/object:RuPHY::Element
  Z: 116
  m: 0.0
  sym: :Uuh
Uuh: *id116
116: *id116
:Uuh: *id116
"117": &id117 !ruby/object:RuPHY::Element
  Z: 117
  m: 0.0
  sym: :Uus
Uus: *id117
117: *id117
:Uus: *id117
"118": &id118 !ruby/object:RuPHY::Element
  Z: 118
  m: 0.0
  sym: :Uuo
Uuo: *id118
118: *id118
:Uuo: *id118
EOY
			Hash = ::YAML.load(YAML)

			def get_elem_data key
				return Hash[key]
			end
		end
	end
end
