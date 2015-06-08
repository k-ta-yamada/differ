require './app'
require 'faker'
require 'factory_girl'
include FactoryGirl::Syntax::Methods
FactoryGirl.find_definitions

puts "Source.unscoped.delete_all=[#{Source.unscoped.delete_all}]"
puts "Target.delete_all=[#{Target.delete_all}]"

# benchmark
if ENV['ENV'] == 'benchmark'
  ActiveRecord::Base.logger.level = Logger::INFO

  10_000.times do |i|
    puts "#{Time.now} #{i}" if i % 100 == 0

    source_cols = {}
    target_cols = {}

    # dummy_col_001-020までランダムに値を設定する
    1.upto(20).each do |num|
      col_nm = "dummy_col_#{sprintf('%03d', num)}".to_sym
      source_cols[col_nm] = Faker::Lorem.word
      target_cols[col_nm] = Faker::Lorem.word
    end

    # dummy_col_050-300までSourceとTargetで一致する値を設定する
    50.upto(300).each do |num|
      word = Faker::Lorem.word
      col_nm = "dummy_col_#{sprintf('%03d', num)}".to_sym
      source_cols[col_nm] = word
      target_cols[col_nm] = word
    end

    create(:source_for_benchmark, source_cols)
    create(:target_for_benchmark, target_cols)
  end
else
  # Source:Target = 1:0
  5.times do
   create(:source, search_key: '1000')
   build_stubbed(:target, search_key: '1000')
 end

  # Source:Target = 1:1
  5.times do
    create(:source, search_key: '1000')
    create(:target, search_key: '1000')
  end

  # Source:Target = 1:N
  5.times do
    source = create(:source, search_key: '1000')
    target = create(:target, search_key: '1000')
    create(:target, dummy_pk: target.dummy_pk, search_key: '1000')
  end

  # Source:Target = N:N
  5.times do
    source = create(:source, search_key: '1000')
    target = create(:target, search_key: '1000')
    create(:source, dummy_pk: source.dummy_pk, search_key: '1000')
    create(:target, dummy_pk: target.dummy_pk, search_key: '1000')
  end

  # 明示的に（追加で）比較対象に設定する項目
  create(:source, search_key: '2000', include_col1_id: 'aaa')
  create(:target, search_key: '2000', include_col1_id: 'bbb')
  create(:source, search_key: '2000', include_col2_id: 'aaa')
  create(:target, search_key: '2000', include_col2_id: 'bbb')

  # 明示的に比較対象から除外する項目
  create(:source, search_key: '3000', exclude_col1: 'aaa')
  create(:target, search_key: '3000', exclude_col1: 'bbb')
  create(:source, search_key: '3000', exclude_col2: 'aaa')
  create(:target, search_key: '3000', exclude_col2: 'bbb')

  # 差異が出てもOKとする項目
  #    :acceptable_col1: [NilClass, String]
  #    :acceptable_col2: [String, NilClass]
  create(:source, search_key: '4001', acceptable_col1: nil)
  create(:target, search_key: '4001', acceptable_col1: 'aaa')
  create(:source, search_key: '4001', acceptable_col2: nil)
  create(:target, search_key: '4001', acceptable_col2: 'aaa')

  # 差異が出てもOKとする項目
  #    :acceptable_col1: [NilClass, String]
  #    :acceptable_col2: [String, NilClass]
  create(:source, search_key: '4002', acceptable_col1: 'aaa')
  create(:target, search_key: '4002', acceptable_col1: nil)
  create(:source, search_key: '4002', acceptable_col2: 'aaa')
  create(:target, search_key: '4002', acceptable_col2: nil)

  # # 適当にたくさん
  # create_list(:target, 1_000, search_key: '9999')
  # create_list(:source, 1_000, search_key: '9999')
end

puts "Source.count=[#{Source.count}]"
puts "Target.count=[#{Target.count}]"
