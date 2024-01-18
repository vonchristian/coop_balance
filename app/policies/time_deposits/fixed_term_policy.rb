module TimeDeposits
  class FixedTermPolicy < ApplicationPolicy
    def new?
      user.teller?
    end

    def create?
      new?
    end
  end
end
