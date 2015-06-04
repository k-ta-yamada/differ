require 'csv'

module DifferHelper
  # 差異発生項目の一覧を返す
  def diff_keys
    return if @result_set.empty?
    @result_set.map(&:diff).map(&:keys).flatten.uniq
  end

  # 指定された項目を差異としてもつ@result_setを返す
  # @return Array-of-Differ
  def results_search(key)
    return if @result_set.empty?
    @result_set.select { |r| r.diff.key?(key.to_sym) }
  end

  # @result_setから項目別の件数を集計する
  # @ return Hash
  def count_by_col
    return if @result_set.empty?
    @result_set.each_with_object(Hash.new(0)) do |r, h|
      r.diff.each { |col_nm, _| h[col_nm] += 1 }
    end
  end

  def output(col_sep = "\t")
    return if @result_set.empty?
    base_file_name = "diff_result_#{@search_value.to_s.ljust(4, 'x') || 'all'}"

    [output_row_multi(base_file_name, col_sep),
     output_acceptable_diff(base_file_name, col_sep),
     output_diff_keys_count(base_file_name)]
  end

  private

  # 差分の出力::項目ごとに1行
  def output_row_multi(base_file_name, col_sep)
    file = "./diff_result/#{base_file_name}_row_multi.csv"
    CSV.open(file, 'w', col_sep: col_sep) do |csv|
      @result_set.sort_by { |r| [r.primary_key, r.target_ext] }.each do |result|
        temp = result_common_attr(result)
        result.diff.each { |col_nm, values| csv << [*temp, col_nm.upcase, *values] }
      end
    end
    file
  end

  # 許容される差分の出力
  def output_acceptable_diff(base_file_name, col_sep)
    file = "./diff_result/#{base_file_name}_tolerate_diff.csv"
    CSV.open("./diff_result/#{base_file_name}_tolerate_diff.csv", 'w', col_sep: col_sep) do |csv|
      @result_set.sort_by { |r| [r.primary_key, r.target_ext] }.each do |r|
        next if r.acceptable_diff.empty?
        temp = result_common_attr(r)
        temp.concat(r.acceptable_diff.to_a.flatten)
        csv << temp
      end
    end
    file
  end

  # 差分項目の一覧を出力
  def output_diff_keys_count(base_file_name)
    file = "./diff_result/#{base_file_name}_diff_keys_count.txt"
    File.open("./diff_result/#{base_file_name}_diff_keys_count.txt", 'w') do |f|
      count_by_col.sort.each do |ary|
        f.puts "#{ary.first.upcase}\t#{ary.last}"
      end
    end
    file
  end

  # @param result Struct::Result
  # Struct::Resultのdiff以外の属性の値を配列にして返す
  def result_common_attr(result)
    [result.primary_key,
     result.search_key,
     result.search_value,
     result.source_ext,
     result.target_ext,
     result.target_idx]
  end

  # #execution_of_diff_by_search_keyで進捗状況出力する部分::単に見苦しいから切り出した
  def progress_log(idx, source_size)
    return unless (idx % 1_000).zero?
    puts "  #{Time.now} "\
         "[#{@search_value}] "\
         "[#{idx.to_s(:delimited).rjust(7)} / #{source_size.to_s(:delimited).rjust(7)}] "\
         "#{Process.pid}"
  end
end
