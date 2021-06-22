class Trade < ApplicationRecord
  belongs_to :carrefour_unit
  belongs_to :item_category
  belongs_to :seller, class_name: "User", optional: true
  belongs_to :buyer, class_name: "User", optional: true
  attr_accessor :created_by
end
