# This will guess the User class
FactoryBot.define do
  factory :item_category do
    name { Faker::Name.first_name }
  end
end