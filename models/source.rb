class Source < ActiveRecord::Base
  include ActiveRecord::Diff

  self.table_name  = AppConfig.models[:source_table_name]
  self.primary_key = AppConfig.models[:source_primary_key]

  has_many :target, foreign_key: AppConfig.models[:source_primary_key]

  # TODO: 定義、記載の順番見直し
  # @ref has_manyやvalidatesなどはクラス定義の最初の方に記述しましょう。（satour注：本文と例が一致していません@原文）
  # @url https://github.com/satour/rails-style-guide/blob/master/README-jaJA.md#macro-style-methods
  default_scope { where.not(primary_key => exclude_keys) }

  # _idで終わる項目はどうやらデフォルトだと
  # 比較対象外になるようなので、全項目を明示的に追加する
  self.diff_attrs = [{ include: AppConfig.differ[:include_keys],
                       exclude: AppConfig.differ[:exclude_keys] }]

  class << self
    # retrun key numbers of same primary key's record.
    # @return Array-of-String
    def exclude_keys
      # HACK: キャッシュしてしまうとテスト時のcreate分が除外対象とならないため非キャッシュ
      if AppConfig.environment == :test
        unscoped.select(primary_key).group(primary_key).having('COUNT(*)>1').pluck(primary_key)
      else
        @exclude_keys ||=
          unscoped.select(primary_key).group(primary_key).having('COUNT(*)>1').pluck(primary_key)
      end
    end

    # scope method
    def search_key_like(search_value = nil, search_key = AppConfig.differ[:search_key])
      # HACK: プレースホルダにするとシングルクォートで囲まれてしまうため、項目名はホワイトリスト形式でチェックする
      key_check(search_key)
      where("#{search_key} LIKE ?", "#{search_value}%")
    end

    private

    def key_check(search_key)
      fail "#{search_key} is not exist white list" unless column_names.include?(search_key.to_s)
    end
  end

  # @tip includesしてれば#sizeで平気みたい。でも#countはだめ。
  # @return Boolean
  def target_has_many?
    target.size > 1
  end
end
