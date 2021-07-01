class User < ApplicationRecord
  has_many :trades, class_name: "Trade", foreign_key: "seller_id"
  has_many :trades, class_name: "Trade", foreign_key: "buyer_id"
  validates :address, presence: true
  validates :cpf, presence: true
  validates :birthdate, presence: true
  validates :phone, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :optin_privacy, presence: true
  after_create :link_user_to_trades
  before_save :clean_phone
  before_save :clean_cpf
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  def name
    "#{first_name} #{last_name}"
  end

  def link_user_to_trades
    @user = User.last 
    Trade.all.each do |trade|
      if @user.phone == trade.receiver_phone 
        trade.update(receiver_name: @user.first_name) if @user.first_name
        trade.author_role == "Vendedor" ? trade.update(buyer: @user) : trade.update(seller: @user)
      end
    end
  end


  def clean_phone
    self.phone = self.phone.delete("(").delete(")").delete("-")
  end

  def clean_cpf
    self.cpf = self.cpf.delete("-").delete("-").delete(".")
  end

end