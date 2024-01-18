module AccountingModule
  class AccountPolicy < ApplicationPolicy
    def new?
      user.accountant? || user.bookkeeper?
    end

    def create?
      new?
    end

    def edit?
      new?
    end

    def update?
      new?
    end
  end
end
