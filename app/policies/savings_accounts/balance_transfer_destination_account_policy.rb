module SavingsAccounts
  class BalanceTransferDestinationAccountPolicy < ApplicationPolicy
    def new?
      can_receive_cash?
    end

    def create?
      new?
    end

    def can_receive_cash?
      user.teller? || user.treasurer?
    end
  end
end
