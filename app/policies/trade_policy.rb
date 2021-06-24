class TradePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.present?
  end

  def show?
    user == record.author
  end

  def update?
    user == record.seller || user == record.buyer || user == record.author
  end

  def destroy?
    user == record.seller || user == record.buyer
  end
end
