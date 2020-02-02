module SavingsAccounts
  class BalanceTransferPolicy < ApplicationPolicy
    def new?
      user.bookkeeper? || user.accountant?
    end

    def create?
      new?
    end
  end
end
