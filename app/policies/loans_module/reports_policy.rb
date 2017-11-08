module LoansModule
  class ReportsPolicy < ApplicationPolicy
    def index?
      user.loan_officer?
    end
  end
end
