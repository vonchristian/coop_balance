module AccountingModule 
  class AccountPolicy < ApplicationPolicy
    def new?
      user.accountant?
    end 
    def create?
      new?
    end 
  end 
end 