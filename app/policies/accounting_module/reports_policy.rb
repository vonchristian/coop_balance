module AccountingModule
  class ReportsPolicy < ApplicationPolicy
    def index?
      user.accountant? || user.bookkeeper?
    end
    def create?
      new?
    end
  end
end
