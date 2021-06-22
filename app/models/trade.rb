class Trade < ApplicationRecord
  belongs_to :carrefour_unit, optional: true
  belongs_to :item_category, optional: true
  belongs_to :seller, class_name: "User", optional: true
  belongs_to :buyer, class_name: "User", optional: true
end
