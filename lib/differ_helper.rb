require 'csv'

module DifferHelper
  # 差異発生項目の一覧を返す
  # @return Array-of-Symbol, NilClass
  def diff_keys
    return if @result_set.empty?
    @result_set.map(&:diff).map(&:keys).flatten.uniq
  end

  # 指定された項目を差異としてもつ@result_setを返す
  # @return Array-of-Differ, NilClass
  def results_search(key)
    return if @result_set.empty?
    @result_set.select { |r| r.diff.key?(key.to_sym) }
  end

  # @result_setから項目別の件数を集計する
  # @ return Hash, NilClass
  def count_by_col
    return if @result_set.empty?
    result = @result_set.each_with_object(Hash.new(0)) do |r, h|
      r.diff.each { |col_nm, _| h[col_nm] += 1 }
    end
    result.sort.to_h
  end

  # @param col_sep String
  # @return Array-of-String
  def output(col_sep = "\t")
    result = []
    return result if @result_set.empty?
    base_file_name = "diff_result_#{@search_value.to_s.ljust(4, 'x') || 'all'}"

    result << output_diff(base_file_name, col_sep)
    result << output_acceptable_diff(base_file_name, col_sep)
    result << output_count_by_col(base_file_name)
  end

  private

  BASE_DIR_NAME = './result/'

  def output_csv_base(file_name, col_sep, attr_name)
    CSV.open(file_name, 'w', external_encoding: Encoding::SJIS, col_sep: col_sep) do |csv|
      @result_set.each do |r|
        r.send(attr_name).each { |k, v| csv << [*common_attr(r), k.upcase, *v] }
      end
    end
    file_name
  end

  # 差分の出力::項目ごとに1行
  def output_diff(base_file_name, col_sep)
    file_name = "#{BASE_DIR_NAME}#{base_file_name}_diff.csv"
    output_csv_base(file_name, col_sep, :diff)
  end

  # 許容される差分の出力
  def output_acceptable_diff(base_file_name, col_sep)
    file_name = "#{BASE_DIR_NAME}#{base_file_name}_acceptable_diff.csv"
    output_csv_base(file_name, col_sep, :acceptable_diff)
  end

  # 差分項目の一覧を出力
  def output_count_by_col(base_file_name)
    file_name = "#{BASE_DIR_NAME}#{base_file_name}_diff_keys_count.txt"
    File.open(file_name, 'w') do |f|
      count_by_col.each { |k, v| f.puts "#{k.upcase}\t#{v}" }
    end
    file_name
  end

  # DifferResultのdiff以外の属性値を配列にして返す
  # @param result DifferResult
  # @return Array
  def common_attr(result)
    [result.primary_key,
     result.search_key,
     result.search_value,
     result.source_ext,
     result.target_ext]
  end

  # Differ#do_find_eachの進捗状況出力要
  # @param idx Fixnum
  # @param source_size Fixnum
  def progress_log(idx, source_size)
    return unless (idx % 1_000).zero?
    puts [' ',
          "#{Time.now} ",
          "[#{@search_value}] ",
          "[#{idx.to_s(:delimited).rjust(7)} / ",
          "#{source_size.to_s(:delimited).rjust(7)}] ",
          "#{Process.pid}"].join(' ')
  end
end
