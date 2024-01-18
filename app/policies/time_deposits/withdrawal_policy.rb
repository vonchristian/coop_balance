module TimeDeposits
  class WithdrawalPolicy < ApplicationPolicy
    def new?
      user.teller? || user.treasurer?
    end

    def create?
      new?
    end
  end
end

