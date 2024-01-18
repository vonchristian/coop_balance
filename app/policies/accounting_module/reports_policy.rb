module AccountingModule
  class ReportsPolicy < ApplicationPolicy
    def index?
      user.accountant? || user.bookkeeper? || user.general_manager? || user.branch_manager?
    end

    def create?
      new?
    end
  end
end
