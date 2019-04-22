module ShareCapitals
  class BalanceTransferPolicy < ApplicationPolicy
    def new?
      user.accountant? || user.teller? || user.bookkeeper?
    end
    def create?
      new?
    end
  end
end
