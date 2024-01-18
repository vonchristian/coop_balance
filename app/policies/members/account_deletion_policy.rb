module Members
  class AccountDeletionPolicy < ApplicationPolicy
    def new?
      user.general_manager? || user.branch_manager?
    end

    def create?
      new?
    end
  end
end
