class DifferResult
  attr_accessor :primary_key,
                :search_key,
                :search_value,
                :source_ext,
                :target_ext,
                :target_idx,
                :diff,
                :acceptable_diff

  def initialize
    @diff = {}
  end

  # 許容される差異をdiffから削除
  def move_to_acceptable_diff!
    acceptables = AppConfig.differ[:acceptable_keys]

    @acceptable_diff = @diff.select do |key, val|
      from_class, to_class = acceptables[key] || [NilClass, NilClass]
      from_val, to_val     = val
      from_val.is_a?(from_class) && to_val.is_a?(to_class)
    end

    # @acceptable_diffに移した項目を@diffから削除する
    @diff.delete_if { |k, _| @acceptable_diff.keys.include?(k) }
    self
  end
end
