class CarrefourUnit < ApplicationRecord
  has_many :trades
  validates :address, presence: true
  validates :name, presence: true
  validates :suburb, presence: true
  validates :cep, presence: true
  validates :city, presence: true
  geocoded_by :full_adress
  after_validation :geocode

  def full_adress
    "#{address}, #{cep}, #{suburb}, #{city}"
  end
end
