class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    user == record
  end

  def create?
    true
  end

  def update?
    user == record
  end

  def destroy?
    user == record
  end

  def invitations?
    user == record
  end
end
