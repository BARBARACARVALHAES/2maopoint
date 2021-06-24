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
    buyer_cep { TestCeps::TEST_CEPS.sample }
    seller_cep { TestCeps::TEST_CEPS.sample }
    receiver_email { [buyer.email, seller.email].sample }
    receiver_name { Faker::Name.first_name }
    author_role { Trade::ROLE.sample }

    trait :trade_location do
      author { association(:user) }
      buyer { nil }
      seller { nil }
      carrefour_unit { nil }
      buyer_accepted { false }
      seller_accepted { false }
      receiver_email { nil }
      receiver_name { nil }
      form_step { :location }
    end

    trait :trade_carrefour_unit do
      author { association(:user) }
      # False number in order not to fetch data from the url CEP
      buyer_cep { '00000000' }
      seller_cep { '00000000' }
      buyer { nil }
      seller { nil }
      buyer_accepted { false }
      seller_accepted { false }
      receiver_email { nil }
      receiver_name { nil }
      lat_buyer { -23.51228463954499 }
      long_buyer { -46.6447953022994 }
      lat_seller { -23.518012622938926 }
      long_seller { -46.6449349059867 }
      form_step { :carrefour_unit }
    end

    trait :trade_invitation do
      buyer { association(:user) }
      seller { association(:user) }
      author { [buyer, seller].sample }
      buyer_accepted { false }
      seller_accepted { false }
      form_step { :invitation }
    end

    factory :trade_location, traits: [:trade_location]
    factory :trade_carrefour_unit, traits: [:trade_carrefour_unit]
    factory :trade_invitation, traits: [:trade_invitation]
  end
end