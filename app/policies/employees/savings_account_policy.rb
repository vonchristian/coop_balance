module Employees
  class SavingsAccountPolicy < ApplicationPolicy
    def new?
      user.teller? || user.treasurer?
    end

    def create?
      new?
    end
  end
end