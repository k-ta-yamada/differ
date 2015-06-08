FactoryGirl.define do
  trait :supprot_attr_by_faker do
    string_col  { Faker::Lorem.characters }
    text_col    { Faker::Lorem.paragraph }
    integer_col { Faker::Number.number(9).to_i }
    float_col   { Faker::Number.decimal(3, 2) }
    decimal_col { Faker::Number.decimal(3, 2) }
    time_col    { Faker::Time.forward }
    date_col    { Faker::Date.forward }
    boolean_col { Faker::Number.digit.to_i.odd? }
    # datetime_col
    # timestamp_col
    # binary_col
  end

  trait :for_banchmark1 do
    dummy_col_001 { Faker::Lorem.word }
    dummy_col_002 { Faker::Lorem.word }
    dummy_col_003 { Faker::Lorem.word }
    dummy_col_004 { Faker::Lorem.word }
    dummy_col_005 { Faker::Lorem.word }
    dummy_col_006 { Faker::Lorem.word }
    dummy_col_007 { Faker::Lorem.word }
    dummy_col_008 { Faker::Lorem.word }
    dummy_col_009 { Faker::Lorem.word }
    dummy_col_010 { Faker::Lorem.word }
    dummy_col_011 { Faker::Lorem.word }
    dummy_col_012 { Faker::Lorem.word }
    dummy_col_013 { Faker::Lorem.word }
    dummy_col_014 { Faker::Lorem.word }
    dummy_col_015 { Faker::Lorem.word }
    dummy_col_016 { Faker::Lorem.word }
    dummy_col_017 { Faker::Lorem.word }
    dummy_col_018 { Faker::Lorem.word }
    dummy_col_019 { Faker::Lorem.word }
    dummy_col_020 { Faker::Lorem.word }
  end

  trait :for_banchmark2 do
    dummy_col_101 Faker::Lorem.word
    dummy_col_102 Faker::Lorem.word
    dummy_col_103 Faker::Lorem.word
    dummy_col_104 Faker::Lorem.word
    dummy_col_105 Faker::Lorem.word
    dummy_col_106 Faker::Lorem.word
    dummy_col_107 Faker::Lorem.word
    dummy_col_108 Faker::Lorem.word
    dummy_col_109 Faker::Lorem.word
    dummy_col_110 Faker::Lorem.word
    dummy_col_111 Faker::Lorem.word
    dummy_col_112 Faker::Lorem.word
    dummy_col_113 Faker::Lorem.word
    dummy_col_114 Faker::Lorem.word
    dummy_col_115 Faker::Lorem.word
    dummy_col_116 Faker::Lorem.word
    dummy_col_117 Faker::Lorem.word
    dummy_col_118 Faker::Lorem.word
    dummy_col_119 Faker::Lorem.word
    dummy_col_120 Faker::Lorem.word
    dummy_col_121 Faker::Lorem.word
    dummy_col_122 Faker::Lorem.word
    dummy_col_123 Faker::Lorem.word
    dummy_col_124 Faker::Lorem.word
    dummy_col_125 Faker::Lorem.word
    dummy_col_126 Faker::Lorem.word
    dummy_col_127 Faker::Lorem.word
    dummy_col_128 Faker::Lorem.word
    dummy_col_129 Faker::Lorem.word
    dummy_col_130 Faker::Lorem.word
    dummy_col_131 Faker::Lorem.word
    dummy_col_132 Faker::Lorem.word
    dummy_col_133 Faker::Lorem.word
    dummy_col_134 Faker::Lorem.word
    dummy_col_135 Faker::Lorem.word
    dummy_col_136 Faker::Lorem.word
    dummy_col_137 Faker::Lorem.word
    dummy_col_138 Faker::Lorem.word
    dummy_col_139 Faker::Lorem.word
    dummy_col_140 Faker::Lorem.word
    dummy_col_141 Faker::Lorem.word
    dummy_col_142 Faker::Lorem.word
    dummy_col_143 Faker::Lorem.word
    dummy_col_144 Faker::Lorem.word
    dummy_col_145 Faker::Lorem.word
    dummy_col_146 Faker::Lorem.word
    dummy_col_147 Faker::Lorem.word
    dummy_col_148 Faker::Lorem.word
    dummy_col_149 Faker::Lorem.word
    dummy_col_150 Faker::Lorem.word
    dummy_col_151 Faker::Lorem.word
    dummy_col_152 Faker::Lorem.word
    dummy_col_153 Faker::Lorem.word
    dummy_col_154 Faker::Lorem.word
    dummy_col_155 Faker::Lorem.word
    dummy_col_156 Faker::Lorem.word
    dummy_col_157 Faker::Lorem.word
    dummy_col_158 Faker::Lorem.word
    dummy_col_159 Faker::Lorem.word
    dummy_col_160 Faker::Lorem.word
    dummy_col_161 Faker::Lorem.word
    dummy_col_162 Faker::Lorem.word
    dummy_col_163 Faker::Lorem.word
    dummy_col_164 Faker::Lorem.word
    dummy_col_165 Faker::Lorem.word
    dummy_col_166 Faker::Lorem.word
    dummy_col_167 Faker::Lorem.word
    dummy_col_168 Faker::Lorem.word
    dummy_col_169 Faker::Lorem.word
    dummy_col_170 Faker::Lorem.word
    dummy_col_171 Faker::Lorem.word
    dummy_col_172 Faker::Lorem.word
    dummy_col_173 Faker::Lorem.word
    dummy_col_174 Faker::Lorem.word
    dummy_col_175 Faker::Lorem.word
    dummy_col_176 Faker::Lorem.word
    dummy_col_177 Faker::Lorem.word
    dummy_col_178 Faker::Lorem.word
    dummy_col_179 Faker::Lorem.word
    dummy_col_180 Faker::Lorem.word
    dummy_col_181 Faker::Lorem.word
    dummy_col_182 Faker::Lorem.word
    dummy_col_183 Faker::Lorem.word
    dummy_col_184 Faker::Lorem.word
    dummy_col_185 Faker::Lorem.word
    dummy_col_186 Faker::Lorem.word
    dummy_col_187 Faker::Lorem.word
    dummy_col_188 Faker::Lorem.word
    dummy_col_189 Faker::Lorem.word
    dummy_col_190 Faker::Lorem.word
    dummy_col_191 Faker::Lorem.word
    dummy_col_192 Faker::Lorem.word
    dummy_col_193 Faker::Lorem.word
    dummy_col_194 Faker::Lorem.word
    dummy_col_195 Faker::Lorem.word
    dummy_col_196 Faker::Lorem.word
    dummy_col_197 Faker::Lorem.word
    dummy_col_198 Faker::Lorem.word
    dummy_col_199 Faker::Lorem.word
    dummy_col_200 Faker::Lorem.word
  end
end
