require 'csv'
require './models/models'
require './lib/differ_helper'
require './lib/differ_result'

class Differ
  # @ref クラス定義は置いて一貫性のある構造にしましょう。
  # @url https://github.com/fortissimo1997/ruby-style-guide/blob/japanese/README.ja.md#consistent-classes
  include DifferHelper

  attr_accessor :result_set,
                :limit,
                :search_key,
                :search_value

  def self.do_perform_with_benchmark
    Benchmark.measure { do_perform }
  end

  # search_valueごとに実行する
  # @param  limit Integer
  # @return Array-of-Differ
  def self.do_perform(limit = 1_000)
    search_values = AppConfig.differ[:search_values]
    all_results = Array(search_values).map do |search_value|
      # 比較実施
      differ = new(limit: limit, search_value: search_value)
      differ.do_perform
    end

    # ファイル出力
    all_results.each(&:output)
    all_results
  end

  def initialize(limit: 1_000, search_value: 11)
    @result_set   = Set.new
    @limit        = limit
    @search_key   = AppConfig.differ[:search_key]
    @search_value = search_value
  end

  # 指定された種目の物件で差分判定し、@result_setに結果を格納
  # @return Differ
  def do_perform
    @result_set.clear
    sources =
      Source.search_key_like(@search_value, @search_key).includes(:target)
    sources_size = sources.size

    sources.find_each.with_index do |source, idx|
      # TODO: find_each内での件数でしかとまらないよって、総数がlimit委譲ある場合は処理継続される
      break if idx > @limit

      progress_log(idx, sources_size)

      # Targetが複数存在する場合（1:Nの場合）はスキップ
      next if source.target_has_many?

      source.target.each_with_index do |target, target_idx|
        @result_set << differ_result(source, target, target_idx)
      end
    end

    puts "  [#{search_value}] sources_size=[#{sources_size}] " \
         "@result_set.count=[#{@result_set.count}]"
    self
  end

  private

  # @param  source Source
  # @param  target Target
  # @param  target_idx Fixnum
  # @return Struct::Result
  # sourceとtargetを比較してその結果を返す
  def differ_result(source, target, target_idx)
    result = DifferResult.new
    result.primary_key  = source.send(Source.primary_key)
    result.search_key   = @search_key
    result.search_value = @search_value
    result.source_ext   = source.try(:source_ext)
    result.target_ext   = source.try(:target_ext)
    result.target_idx   = target_idx

    # 比較する
    result.diff = diff_execution(source, target)

    # 許容される差異をdiffからtolerateに移動する
    result.move_to_acceptable_diff!
  end

  # @param  source Source
  # @param  target Target
  # @return Hash
  def diff_execution(source, target)
    # _idで終わる項目はどうやらデフォルトだと
    # 比較対象外になるようなので、全項目を明示的に追加する
    Source.diff_attrs = [{ include: AppConfig.differ[:include_keys],
                           exclude: AppConfig.differ[:exclude_keys] }]
    # 比較する
    source.diff(target)
  end
end
