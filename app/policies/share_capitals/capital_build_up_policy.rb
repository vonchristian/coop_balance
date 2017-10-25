module ShareCapitals
  class CapitalBuildUpPolicy < ApplicationPolicy
    def new?
      user.teller? || user.treasurer?
    end
    def create?
      new?
    end
  end
end
