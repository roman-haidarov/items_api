FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "1234" }
    name { Faker::Name.name }
    born_years { Faker::Number.rand(100) }
  end
end
