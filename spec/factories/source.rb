FactoryGirl.define do
  factory :source do
    sequence :dummy_pk
    search_key '4400'

    factory :source_for_benchmark do
      string_col 'hello'
      text_col 'hello'
      integer_col 1
      float_col 1.234
      decimal_col 4.321
      boolean_col true
    end
  end
end
