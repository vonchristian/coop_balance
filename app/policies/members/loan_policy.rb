module Members
  class LoanPolicy < ApplicationPolicy
    def new?
      user.loan_officer?
    end

    def create?
      new?
    end
  end
end
