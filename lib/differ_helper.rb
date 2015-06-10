require 'csv'

module DifferHelper
  # 差分の出力::項目ごとに1行
  def output_diff(col_sep = "\t")
    file_name = "#{file_name_preffix}_diff.csv"
    output_csv_base(file_name, col_sep, :diff)
  end

  # 許容される差分の出力
  def output_acceptable_diff(col_sep = "\t")
    file_name = "#{file_name_preffix}_acceptable_diff.csv"
    output_csv_base(file_name, col_sep, :acceptable_diff)
  end

  # 差分項目の一覧を出力
  def output_count_by_col
    file_name = "#{file_name_preffix}_count_by_col.txt"
    file = "#{BASE_DIR_NAME}#{file_name}"
    options = { external_encoding: OUTPUT_FILE_ENCODING }
    File.open(file, 'w', options) do |f|
      count_by_col.each { |k, v| f.puts "#{k.upcase}\t#{v}" }
    end
    file
  end

  private

  # @result_setから項目別の件数を集計する
  # @ return Hash
  def count_by_col
    return {} if @result_set.empty?
    result = @result_set.each_with_object(Hash.new(0)) do |r, h|
      r.diff.each { |col_nm, _| h[col_nm] += 1 }
    end
    result.sort.to_h
  end

  BASE_DIR_NAME = './result/'
  OUTPUT_FILE_ENCODING = AppConfig.differ[:output_file_encoding]

  def file_name_preffix
    "#{@search_value.to_s.ljust(4, 'x')}"
  end

  def output_csv_base(file_name, col_sep, attr_name)
    file = "#{BASE_DIR_NAME}#{file_name}"
    options = { external_encoding: OUTPUT_FILE_ENCODING,
                col_sep: col_sep }
    CSV.open(file, 'w', options) do |csv|
      @result_set.each do |r|
        r.send(attr_name).each { |k, v| csv << [*common_attr(r), k.upcase, *v] }
      end
    end
    file
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
          "#{Time.now}",
          "[#{@search_value}]",
          "[#{idx.to_s(:delimited).rjust(7)}",
          '/',
          "#{source_size.to_s(:delimited).rjust(7)}]",
          "#{Process.pid}"].join(' ')
  end
end
