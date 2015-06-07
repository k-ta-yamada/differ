require './models/models'
require './lib/differ_helper'
require './lib/differ_result'
require 'parallel'

class Differ
  # @ref クラス定義は置いて一貫性のある構造にしましょう。
  # @url https://github.com/fortissimo1997/ruby-style-guide/blob/japanese/README.ja.md#consistent-classes
  include DifferHelper

  attr_accessor :result_set,
                :search_key,
                :search_value

  class << self
    def do_perform_with_benchmark(num = 5)
      (1..num).map do |i|
        puts "benchmark do perform [#{i} of #{num}] #{Time.now}"
        Benchmark.realtime { do_perform }
      end
    end

    # search_valueごとに実行する
    # @return Array-of-Differ
    def do_perform
      all_results = AppConfig.differ[:search_values].map do |search_value|
        differ = new(search_value: search_value)
        differ.do_perform
      end

      # ファイル出力
      ap all_results.map(&:output) unless AppConfig.environment == :benchmark
      all_results
    end
  end

  def initialize(search_value: 11)
    @result_set   = Set.new
    @search_key   = AppConfig.differ[:search_key]
    @search_value = search_value
  end

  # 指定された種目の物件で差分判定し、@result_setに結果を格納
  # @return Differ
  def do_perform
    @result_set.clear
    # HACK: OS判定暫定処理
    @result_set = RUBY_PLATFORM.match(/darwin/) ? do_parallel : do_find_each
    self
  end

  private

  # @return Set-of-DifferResult
  def do_parallel
    Parallel.map(primary_keys.each_slice(1_000), parallel_options) do |pks|
      Source.where(Source.primary_key => pks).includes(:target).map do |src|
        diff(src) unless src.target.many?
      end
    end.flatten.compact.to_set
  end

  # @return Array-of-String
  def primary_keys
    Source.search_key_like(@search_value, @search_key).pluck(Source.primary_key)
  end

  # @return Hash
  def parallel_options
    { in_processes: Parallel.processor_count,
      progress: '  '\
                "#{@search_key}=[#{@search_value}]"\
                "#{primary_keys.size.to_s(:delimited).rjust(9)}" }
  end

  # @return Set-of-DifferResult
  def do_find_each
    sources =
      Source.search_key_like(@search_value, @search_key).includes(:target)
    sources_size = sources.size
    result = []
    sources.find_each.with_index do |src, idx|
      progress_log(idx, sources_size)
      result << diff(src) unless src.target.many?
    end
    result.to_set
  end

  # @param  src Source
  # @return Struct::Result
  # sourceとtargetを比較してその結果を返す
  def diff(src)
    result = DifferResult.new
    result.primary_key  = src.send(Source.primary_key)
    result.search_key   = @search_key
    result.search_value = @search_value
    # result.source_ext   = src.try(:source_ext)
    # result.target_ext   = src.try(:target_ext)

    # 比較する
    result.diff = src.diff(src.target.first)

    # 許容される差異をdiffからtolerateに移動する
    result.move_to_acceptable_diff!
  end
end
