class Source < ActiveRecord::Base
  include ActiveRecord::Diff

  self.table_name  = AppConfig.models[:source_table_name]
  self.primary_key = AppConfig.models[:source_primary_key]
  # _idで終わる項目はどうやらデフォルトだと
  # 比較対象外になるようなので、全項目を明示的に追加する
  self.diff_attrs =
    [{ include: AppConfig.differ[:include_keys].map(&:to_sym),
       exclude: AppConfig.differ[:exclude_keys].map(&:to_sym) }]

  has_many :target, foreign_key: AppConfig.models[:source_primary_key]

  default_scope { where.not(primary_key => exclude_keys) }

  class << self
    # retrun key numbers of same primary key's record.
    # @return Array-of-String
    # rubocop:disable Metrics/AbcSize
    def exclude_keys
      # HACK: キャッシュするとテスト時create分が除外対象とならないため非キャッシュ
      if AppConfig.environment == :test
        unscoped.select(primary_key).group(primary_key)
          .having('COUNT(*)>1').pluck(primary_key)
      else
        @exclude_keys ||= unscoped.select(primary_key).group(primary_key)
                          .having('COUNT(*)>1').pluck(primary_key)
      end
    end
    # rubocop:enable Metrics/AbcSize

    # scope method
    # @param search_value
    # @param search_key
    def search_key_like(search_value = nil,
                        search_key = AppConfig.differ[:search_key])
      # HACK: プレースホルダにするとシングルクォートで囲まれてしまうため、
      #   項目名はホワイトリスト形式でチェックする
      key_check(search_key)
      where("#{search_key} LIKE ?", "#{search_value}%")
    end

    private

    def key_check(search_key)
      unless column_names.include?(search_key.to_s)
        fail "Source#key_check[#{search_key}]"
      end
    end
  end
end
