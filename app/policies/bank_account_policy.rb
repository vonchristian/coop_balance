class BankAccountPolicy < ApplicationPolicy
  def new?
    user.treasurer? || user.teller?
  end
  def create?
    new?
  end
end
