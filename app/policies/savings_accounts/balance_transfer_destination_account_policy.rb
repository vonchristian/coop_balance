module SavingsAccounts
  class BalanceTransferDestinationAccountPolicy < ApplicationPolicy
    def new?
      user.bookkeeper? || user.accountant?
    end

    def create?
      new?
    end
  end
end
