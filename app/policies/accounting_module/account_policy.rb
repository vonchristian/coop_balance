module AccountingModule
  class AccountPolicy < ApplicationPolicy
    def new?
      user.accountant? || user.bookkeeper?
    end
    def create?
      new?
    end
  end
end
