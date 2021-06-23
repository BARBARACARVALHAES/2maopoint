FactoryBot.define do
  factory :trade do
    buyer { association(:user) }
    seller { association(:user) }
    carrefour_unit
    item_category
    date { Faker::Time.between(from: DateTime.now, to: DateTime.now + 30) }
    buyer_accepted { false }
    seller_accepted { false }
    item { Faker::Lorem.word }
    buyer_cep { Faker::Address.postcode }
    seller_cep { Faker::Address.postcode }
    receiver_email { [buyer.email, seller.email].sample }
    author { Trade::AUTHOR.sample }
  end
end