module ShareCapitals
  class AccountMergingPolicy < ApplicationPolicy
    def new?
      user.general_manager?
    end

    def create?
      new?
    end
  end
end
