require 'yaml'

module AppConfig
  class << self
    # 環境変数を返す
    # @return Symbol
    def environment
      @environment ||= ENV['ENV'].nil? ? :development : ENV['ENV'].to_sym
    end

    # データベース接続情報を返す
    # @return Hash
    def database
      @database ||= load_file_database_setting(__method__)
    end

    # モデル設定用の情報を返す
    # @return Hash
    def models
      @models ||= loading_models_setting(__method__)
    end

    # 比較処理設定用の情報を返す
    # @return Hash
    def differ
      @differ ||= loading_differ_settings(__method__)
    end

    private

    CONFIG_BASE_DIR = './config'

    def sub_dir
      environment == :production ? '/production/' : '/'
    end

    def load_yaml(method_name)
      YAML.load_file("#{CONFIG_BASE_DIR}#{sub_dir}#{method_name}.yml")[environment]
    end

    def load_file_database_setting(method_name)
      load_yaml(method_name)
    end

    def loading_models_setting(method_name)
      file_name = "#{method_name}.yml"
      be_included = %i(source_table_name
                       source_primary_key
                       target_table_name
                       target_primary_key)

      doc = load_yaml(method_name)
      key_check(doc.keys, be_included, file_name)
      doc
    end

    def loading_differ_settings(method_name)
      file_name = "#{method_name}.yml"
      be_included = %i(search_key
                       search_values
                       include_keys
                       exclude_keys
                       acceptable_keys)

      doc = load_yaml(method_name)
      key_check(doc.keys, be_included, file_name)

      doc[:acceptable_keys] = doc[:acceptable_keys].each_with_object({}) do |kv, obj|
        obj[kv.first] = kv.last.map(&:constantize)
      end
      doc
    end

    # @ref 対称差、すなわち、2 つの集合のいずれか一方にだけ属するすべての要素からなる 新しい集合を作ります。
    # @url http://docs.ruby-lang.org/ja/2.1.0/method/Set/i/=5e.html
    def key_check(doc_keys, be_included, file_name)
      result = doc_keys.to_set ^ be_included.to_set
      fail "[#{file_name}] #{result.inspect}" if result.present?
    end
  end
end