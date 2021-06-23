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

    trait :trade_infos do
      author { association(:user) }
      buyer { nil }
      seller { nil }
      carrefour_unit { nil }
      item_category { nil }
      date { nil }
      buyer_accepted { false }
      seller_accepted { false }
      item { nil }
      buyer_cep { nil }
      seller_cep { nil }
      receiver_email { nil }
      author_role { nil }
      form_step { :infos }
    end

    trait :trade_location do
      author { association(:user) }
      buyer { nil }
      seller { nil }
      carrefour_unit { nil }
      date { nil }
      buyer_accepted { false }
      seller_accepted { false }
      buyer_cep { nil }
      seller_cep { nil }
      receiver_email { nil }
      form_step { :location }
    end

    trait :trade_invitation do
      author { association(:user) }
      buyer { nil }
      seller { nil }
      buyer_accepted { false }
      seller_accepted { false }
      receiver_email { nil }
      form_step { :invitation }
    end

    factory :trade_infos, traits: [:infos]
    factory :trade_location, traits: [:location]
    factory :trade_invitation, traits: [:invitation]
  end
end