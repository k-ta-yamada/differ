require './app'

p Source.unscoped.delete_all
p Target.delete_all

1.upto(10).each do |i|
  Source.create(dummy_pk: sprintf('%010d', i), search_key: 1101)
  Target.create(dummy_pk: sprintf('%010d', i), search_key: 1101)

  if (rand * 10).ceil.odd?
    Target.create(dummy_pk: sprintf('%010d', i), search_key: 1101)
  end
end

Source.create(dummy_pk: sprintf('%010d', 1), search_key: 1101)

puts Source.unscoped.count
puts Target.count
puts Source.all
puts Source.all.select { |src| src.target.size > 1 }.map(&:dummy_pk)

# 差分となるデータの作成 => string
Source.create(dummy_pk: sprintf('%010d', 101), search_key: 1101, string_col: 'hello')
Target.create(dummy_pk: sprintf('%010d', 101), search_key: 1101, string_col: 'bye')
# 差分となるデータの作成 => text
Source.create(dummy_pk: sprintf('%010d', 102), search_key: 1101, text_col: 'hello')
Target.create(dummy_pk: sprintf('%010d', 102), search_key: 1101, text_col: 'bye')
# 差分となるデータの作成 => integer
Source.create(dummy_pk: sprintf('%010d', 103), search_key: 1101, integer_col: 1)
Target.create(dummy_pk: sprintf('%010d', 103), search_key: 1101, integer_col: 2)
# 差分となるデータの作成 => float
Source.create(dummy_pk: sprintf('%010d', 104), search_key: 1101, float_col: 1.123)
Target.create(dummy_pk: sprintf('%010d', 104), search_key: 1101, float_col: 2.123)
# 差分となるデータの作成 => decimal
Source.create(dummy_pk: sprintf('%010d', 105), search_key: 1101, decimal_col: 1.123)
Target.create(dummy_pk: sprintf('%010d', 105), search_key: 1101, decimal_col: 2.123)
# 差分となるデータの作成 => boolean
Source.create(dummy_pk: sprintf('%010d', 106), search_key: 1101, boolean_col: true)
Target.create(dummy_pk: sprintf('%010d', 106), search_key: 1101, boolean_col: false)
# 差分となるデータの作成 => datetime
# 差分となるデータの作成 => timestamp
# 差分となるデータの作成 => time
# 差分となるデータの作成 => date
# 差分となるデータの作成 => binary

# 明示的に比較対象とする項目
Source.create(dummy_pk: sprintf('%010d', 201), search_key: 1101, include_col1_id: 'aaa')
Target.create(dummy_pk: sprintf('%010d', 201), search_key: 1101, include_col1_id: 'bbb')
Source.create(dummy_pk: sprintf('%010d', 202), search_key: 1101, include_col2_id: 'aaa')
Target.create(dummy_pk: sprintf('%010d', 202), search_key: 1101, include_col2_id: 'bbb')

# 明示的に比較対象から除外する項目
Source.create(dummy_pk: sprintf('%010d', 301), search_key: 1101, exclude_col1: 'aaa')
Target.create(dummy_pk: sprintf('%010d', 301), search_key: 1101, exclude_col1: 'bbb')
Source.create(dummy_pk: sprintf('%010d', 302), search_key: 1101, exclude_col2: 'aaa')
Target.create(dummy_pk: sprintf('%010d', 302), search_key: 1101, exclude_col2: 'bbb')

# 差異が出てもOKとする項目
#    :acceptable_col1: [NilClass, String]
#    :acceptable_col2: [String, NilClass]
Source.create(dummy_pk: sprintf('%010d', 401), search_key: 1101, acceptable_col1: nil)
Target.create(dummy_pk: sprintf('%010d', 401), search_key: 1101, acceptable_col1: 'bbb')
Source.create(dummy_pk: sprintf('%010d', 402), search_key: 1101, acceptable_col1: 'aaa')
Target.create(dummy_pk: sprintf('%010d', 402), search_key: 1101, acceptable_col1: nil)

Source.create(dummy_pk: sprintf('%010d', 403), search_key: 1101, acceptable_col2: nil)
Target.create(dummy_pk: sprintf('%010d', 403), search_key: 1101, acceptable_col2: 'bbb')
Source.create(dummy_pk: sprintf('%010d', 404), search_key: 1101, acceptable_col2: 'aaa')
Target.create(dummy_pk: sprintf('%010d', 404), search_key: 1101, acceptable_col2: nil)

# performance
if ENV['ENV'] == 'benchmark'
  10_000.times do |i|
    p i if i % 100 == 0
    Source.create(dummy_pk: sprintf('%010d', 1_000_000_000 + i), search_key: 4400)
    Target.create(dummy_pk: sprintf('%010d', 1_000_000_000 + i), search_key: 4400)
  end
end

puts Source.count
puts Target.count
