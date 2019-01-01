module ShareCapitals
  class BalanceTransferPolicy < ApplicationPolicy
    def new?
      user.accountant? || user.teller?
    end
    def create?
      new?
    end
  end
end
