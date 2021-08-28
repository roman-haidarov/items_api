FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Base64.encode64("1234") }
    name { Faker::Name.name }
    born_years { Faker::Number.rand(100) }
  end
end
