class User < ApplicationRecord
  has_many :trades, class_name: "Trade", foreign_key: "seller_id"
  has_many :trades, class_name: "Trade", foreign_key: "buyer_id"
  validates :address, presence: true
  validates :cpf, presence: true
  validates :birthdate, presence: true
  validates :phone, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  def name
    "#{first_name} #{last_name}"
  end
end
