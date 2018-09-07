module AccountingModule
  class EntryPolicy < ApplicationPolicy
    def new?
      user.accountant? || user.bookkeeper?
    end
    def create?
      new?
    end
  end
end
