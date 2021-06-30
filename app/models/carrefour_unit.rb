class CarrefourUnit < ApplicationRecord
  has_many :trades
  validates :address, presence: true
  validates :name, presence: true
  validates :suburb, presence: true
  validates :cep, presence: true
  validates :city, presence: true
  geocoded_by :full_address
  after_validation :geocode, if: ->(obj) { obj.full_address.present? && (obj.address_changed? || obj.suburb_changed? || obj.cep_changed? || obj.city_changed?) }

  def full_address
    # Nao botar CEP e Suburb aqui, isso atrapalha mais do que outra coisa
    "#{address}, #{city}"
  end
end
