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

  CARREFOUR_UNITS = [{
    name: "Carrefour Hipermercado Jabaquara",
    address: "Avenida Engenheiro George Corbisier, 273",
    city: "São Paulo",
    cep: "04345000",
    suburb: "Jabaquara"
  }, {
    name: "Carrefour Hipermercado Limão",
    address: "Avenida Otaviano Alves de Lima, 1824",
    city: "São Paulo",
    cep: "02701000",
    suburb: "Limão"
  }, {
    name: "Carrefour Hipermercado Cambuci",
    address: "Praça Alberto Lion, 100",
    city: "São Paulo",
    cep: "01515000",
    suburb: "Cambuci"
  }, {
    name: "Carrefour Hypermarket Tietê",
    address: "Avenida Morvan Dias de Figueiredo, 3177",
    city: "São Paulo",
    cep: "02063002",
    suburb: "Vila Guilherme"
  }]
end
