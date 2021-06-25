class User < ApplicationRecord
  has_many :trades, class_name: "Trade", foreign_key: "seller_id"
  has_many :trades, class_name: "Trade", foreign_key: "buyer_id"
  after_create :link_user_to_trades

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def name
    "#{first_name} #{last_name}"
  end

  def link_user_to_trades
    @user = User.last 
    Trade.all.each do |trade|
      if @user.email == trade.receiver_email 
        trade.update(receiver_name: @user.first_name) if @user.first_name
        trade.author_role == "Vendedor" ? trade.update(buyer: @user) : trade.update(seller: @user)
      end
    end
  end
end
