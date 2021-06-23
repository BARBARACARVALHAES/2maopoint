FactoryBot.define do
  factory :trade do
    buyer { association(:user) }
    seller { association(:user) }
    author { [buyer, seller].sample }
    carrefour_unit
    item_category
    date { Faker::Time.between(from: DateTime.now, to: DateTime.now + 30) }
    buyer_accepted { false }
    seller_accepted { false }
    item { Faker::Lorem.word }
    buyer_cep { Faker::Address.postcode }
    seller_cep { Faker::Address.postcode }
    receiver_email { [buyer.email, seller.email].sample }
    author_role { Trade::ROLE.sample }
  end
end