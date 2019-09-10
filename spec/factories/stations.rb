FactoryBot.define do
  factory :station do
    association :region, factory: :region

    name { "渋谷" }
  end
end
