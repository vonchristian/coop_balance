module TimeDeposits
  class BreakContractPolicy < ApplicationPolicy
    def new?
      user.teller? || user.treasurer?
    end

    def create?
      new?
    end
  end
end
