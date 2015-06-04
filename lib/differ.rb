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
    def do_perform_with_benchmark
      puts 'benchmark do perform!!'
      pp Benchmark.measure { do_perform }
    end

    # search_valueごとに実行する
    # @return Array-of-Differ
    def do_perform
      search_values = AppConfig.differ[:search_values]
      all_results = Array(search_values).map do |search_value|
        puts "#{Time.now} search_value=[#{search_value}] is start."

        # 比較実施
        differ = new(search_value: search_value)
        differ.do_perform

        puts "#{Time.now} search_value=[#{search_value}] is end."
        puts
        differ
      end

      # ファイル出力
      all_results.each(&:output) unless AppConfig.environment == :benchmark
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
    sources = Source.search_key_like(@search_value, @search_key).includes(:target)
    sources_size = sources.size

    # HACK: OS判定暫定処理
    if RUBY_PLATFORM == 'x86_64-darwin14.0'
      puts '  execute [perform_parallel]'
      perform_parallel(sources, sources_size).flatten.each { |r| @result_set << r }
    else
      puts '  execute [perform_none_parallel]'
      perform_none_parallel(sources, sources_size).each { |r| @result_set << r }
    end

    puts "  @result_set.count=[#{@result_set.count}]"
    self
  end

  private

  # @param sources
  # @param sources_size
  # @return Array-of-DifferResult
  def perform_parallel(sources, sources_size)
    Parallel.map(sources.find_in_batches,
                 in_processes: Parallel.processor_count - 1) do |sliced_sources|
      sliced_sources.map.with_index do |source, idx|
        progress_log(idx, sources_size)
        next if source.target_has_many? # Targetが複数存在する場合（1:Nの場合）はスキップ
        differ_result(source, source.target.first)
      end
    end
  end

  # @param sources
  # @param sources_size
  # @return Array-of-DifferResult
  def perform_none_parallel(sources, sources_size)
    result_set = []
    sources.find_each.with_index do |source, idx|
      progress_log(idx, sources_size)
      next if source.target_has_many? # Targetが複数存在する場合（1:Nの場合）はスキップ
      result_set << differ_result(source, source.target.first)
    end
    result_set
  end

  # @param  source Source
  # @param  target Target
  # @param  target_idx Fixnum
  # @return Struct::Result
  # sourceとtargetを比較してその結果を返す
  def differ_result(source, target)
    result = DifferResult.new
    result.primary_key  = source.send(Source.primary_key)
    result.search_key   = @search_key
    result.search_value = @search_value
    result.source_ext   = source.try(:source_ext)
    result.target_ext   = source.try(:target_ext)
    # result.target_idx   = target_idx

    # 比較する
    # result.diff = diff_execution(source, target)
    result.diff = source.diff(target)

    # 許容される差異をdiffからtolerateに移動する
    result.move_to_acceptable_diff!
  end
end
