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
    def config_dir
      case environment
      when :production
        "#{CONFIG_BASE_DIR}/production/"
      else
        "#{CONFIG_BASE_DIR}/"
      end
    end

    def load_yaml(method_name)
      file_name = "#{config_dir}#{method_name}.yml"
      YAML.load_file(file_name)[environment]
    end

    def load_file_database_setting(method_name)
      load_yaml(method_name)
    end

    MODELS_BE_INCLUDED = %i(source_table_name
                            source_primary_key
                            target_table_name
                            target_primary_key)
    def loading_models_setting(method_name)
      doc = load_yaml(method_name)
      key_check(doc, MODELS_BE_INCLUDED, method_name)
    end

    DIFFER_BE_INCLUDED = %i(search_key
                            search_values
                            include_keys
                            exclude_keys
                            acceptable_keys
                            output_file_encoding)
    def loading_differ_settings(method_name)
      doc = load_yaml(method_name)
      doc = key_check(doc, DIFFER_BE_INCLUDED, method_name)
      edit_differ_setting(doc)
    end

    def edit_differ_setting(doc)
      doc[:acceptable_keys] = doc[:acceptable_keys].each_with_object({}) do |kv, obj|
        obj[kv.first] = kv.last.map(&:constantize)
      end
      doc[:output_file_encoding] = doc[:output_file_encoding].constantize
      doc
    end

    def key_check(doc, be_included, method_name)
      result = doc.keys.to_set ^ be_included.to_set
      fail "[#{method_name}] #{result.inspect}" if result.present?
      doc
    end
  end
end
