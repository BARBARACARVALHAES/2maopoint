FactoryBot.define do
  factory :carrefour_unit do
    name { Faker::Company.name }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    cep { TestCeps::TEST_CEPS.sample }
    suburb { Faker::Address.city }
    latitude { rand(-23.701420495330392..-23.458942508769738) }
    longitude { rand(-46.8124555391923..-46.457071538413445) }
  end
end
