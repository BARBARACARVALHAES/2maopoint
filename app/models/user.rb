class User < ApplicationRecord
  has_many :trades, class_name: "Trade", foreign_key: "seller_id"
  has_many :trades, class_name: "Trade", foreign_key: "buyer_id"

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def name
    "#{first_name} #{last_name}"
  end
end
