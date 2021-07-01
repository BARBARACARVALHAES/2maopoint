class TradePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.present?
  end

  # Usado para a gem wicked para mostrar o form em varios paginas (qualquer usuario pode acessar)
  def show?
    user.present?
  end

  def update?
    user == record.seller || user == record.buyer || user == record.author
  end

  def destroy?
    user == record.seller || user == record.buyer
  end

  def realized_trade?
    update?
  end

  def confirm_presence?
    user == record.seller || user == record.buyer
  end

  def confirm_screen?
    confirm_presence?
  end
end
