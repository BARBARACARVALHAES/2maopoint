FactoryBot.define do
  factory :item_category do
    name { ItemCategory::ITEM_CATEGORIES.sample }
  end
end