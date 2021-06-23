FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    sequence(:email) { |n| "test#{n}@test.com" }
    address { Faker::Address.street_address }
    password { '123456' }
    birthdate { Faker::Date.between(from: '1993-09-23', to: '1993-09-25') }
  end
end