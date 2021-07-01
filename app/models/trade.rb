class Trade < ApplicationRecord

  belongs_to :carrefour_unit, optional: true
  belongs_to :item_category, optional: true
  belongs_to :seller, class_name: "User", optional: true
  belongs_to :buyer, class_name: "User", optional: true
  belongs_to :author, class_name: "User"

  ROLE = ["Vendedor", "Comprador"]

  enum form_steps: {
    infos: %i[item item_category_id author_role],
    location: %i[date buyer_cep seller_cep lat_seller long_seller lat_buyer long_buyer],
    carrefour_unit: %i[carrefour_unit_id],
    invitation: %i[receiver_name receiver_phone receiver_email]
  }
  attr_accessor :form_step

  def confirmed?
    buyer_accepted && seller_accepted
  end

  def invited
    author == buyer ? seller : buyer
  end

  def created_by_seller?
    author_role == "Vendedor"
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
    validate :verify_cep
  end

  with_options if: -> { required_for_step?(:carrefour_unit) } do
    validates :carrefour_unit_id, presence: true
  end

  with_options if: -> { required_for_step?(:invitation) } do
    validates :receiver_name, presence: true
    validates :receiver_phone, presence: true
  end

  def required_for_step?(step)
    # All fields are required if no form step is present
    return true if form_step.nil?

    # All fields from previous steps are required
    ordered_keys = self.class.form_steps.keys.map(&:to_sym)
    !!(ordered_keys.index(step) <= ordered_keys.index(form_step))
  end

  def verify_cep
    regexp_cep = /^\d{5}(-?)\d{3}$/

    unless buyer_cep.present? && buyer_cep.match?(regexp_cep)
      errors.add :buyer_cep, "não é valido"
    end

    unless seller_cep.present? && seller_cep.match?(regexp_cep)
      errors.add :seller_cep, "não é valido"
    end
  end
end
