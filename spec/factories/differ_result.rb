FactoryGirl.define do
  factory :differ_result do
    sequence :primary_key
    search_key :search_key
    search_value 11

    # 許容される差分のみ
    trait :acceptables do
      diff acceptable_col1: [nil, 'text'], acceptable_col2: ['text', nil]
    end

    # 許容される差分の項目だが、値の組み合わせが対象外
    trait :unacceptables do
      diff acceptable_col1: [1, 'text'], acceptable_col2: ['text', 1]
    end

    trait :diff1 do
      diff a: [1, 2], b: [1, 2]
    end

    trait :diff2 do
      diff a: [1, 2], c: [1, 2]
    end

    trait :diff3 do
      diff b: [1, 2], c: [1, 2]
    end
  end
end
