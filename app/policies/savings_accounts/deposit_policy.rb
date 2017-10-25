module SavingsAccounts
  class DepositPolicy < ApplicationPolicy
    def new?
      user.teller? || user.treasurer?
    end
    def create?
      new?
    end
  end
end
