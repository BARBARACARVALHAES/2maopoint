class Trade < ApplicationRecord
  belongs_to :carrefour_unit, optional: true
  belongs_to :item_category, optional: true
  belongs_to :seller, class_name: "User", optional: true
  belongs_to :buyer, class_name: "User", optional: true
  belongs_to :author, class_name: "User"

  ROLE = ["Vendedor", "Comprador"]

  enum form_steps: {
    infos: %i[item item_category_id author_role],
    location: %i[date buyer_cep seller_cep],
    carrefour_unit: %i[carrefour_unit_id],
    invitation: [:receiver_email]
  }
  attr_accessor :form_step

  def invited
    author == buyer ? seller : buyer
  end

  with_options if: -> { required_for_step?(:infos) } do
    validates :item, presence: true
    validates :item_category_id, presence: true
    validates :author, presence: true
  end

  with_options if: -> { required_for_step?(:location) } do
    validates :date, presence: true
    validates :buyer_cep, presence: true
    validates :seller_cep, presence: true
  end

  with_options if: -> { required_for_step?(:carrefour_unit) } do
    validates :carrefour_unit_id, presence: true
  end

  with_options if: -> { required_for_step?(:invitation) } do
    validates :receiver_email, presence: true
    validates :receiver_name, presence: true
  end

  def required_for_step?(step)
    # All fields are required if no form step is present
    return true if form_step.nil?

    # All fields from previous steps are required
    ordered_keys = self.class.form_steps.keys.map(&:to_sym)
    !!(ordered_keys.index(step) <= ordered_keys.index(form_step))
  end
end
