FactoryBot.define do
  factory :item do
    name { Faker::Lorem.word }
    price { Faker::Number.rand(100) }
  end
end
