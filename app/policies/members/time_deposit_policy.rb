module Members 
  class TimeDepositPolicy < ApplicationPolicy
    def new?
      user.teller? || user.treasurer?
    end
    def create?
      new?
    end
  end
end