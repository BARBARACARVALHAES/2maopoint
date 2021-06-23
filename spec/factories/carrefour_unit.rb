FactoryBot.define do
  factory :carrefour_unit do
    name { Faker::Company.name }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    cep { Faker::Address.postcode }
    suburb { Faker::Address.community }
  end
end
