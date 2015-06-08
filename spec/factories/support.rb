FactoryGirl.define do
  trait :supprot_attr_by_faker do
    string_col  { Faker::Lorem.characters }
    text_col    { Faker::Lorem.paragraph }
    integer_col { Faker::Number.number(9).to_i }
    float_col   { Faker::Number.decimal(3, 2) }
    decimal_col { Faker::Number.decimal(3, 2) }
    time_col    { Faker::Time.forward }
    date_col    { Faker::Date.forward }
    boolean_col { Faker::Number.digit.to_i.odd? }
    # datetime_col
    # timestamp_col
    # binary_col
  end
end
