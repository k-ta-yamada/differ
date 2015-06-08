FactoryGirl.define do
  factory :target, traits: [:supprot_attr_by_faker] do
    sequence :dummy_pk
    search_key '0000'
  end
end
