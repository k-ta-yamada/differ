require 'faker'

FactoryGirl.define do
  factory :target do
    sequence :dummy_pk
    search_key '4400'

    factory :target_for_benchmark do
      string_col Faker::Name.name
      text_col Faker::Lorem.sentence
      integer_col 2
      float_col 1.234
      decimal_col 4.321
      boolean_col true
    end
  end
end
