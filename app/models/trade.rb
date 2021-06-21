class Trade < ApplicationRecord
  belongs_to :carrefour_unit
  belongs_to :item_category
  belongs_to :seller_id, class_name: "User"
  belongs_to :buyer_id, class_name: "User"
end
