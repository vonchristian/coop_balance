module Employees
  class CashOnHandAccountPolicy < ApplicationPolicy
    def edit?
      user.general_manager? || user.accountant? || user.bookkeeper?
    end
    def update?
      edit?
    end
  end
end
