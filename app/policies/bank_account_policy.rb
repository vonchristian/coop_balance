class BankAccountPolicy < ApplicationPolicy
  def new?
    user.treasurer?
  end
  def create?
    new?
  end
end
