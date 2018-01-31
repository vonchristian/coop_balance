module StoreFrontModule
  class ProductPolicy < ApplicationPolicy
    def new?
      user.stock_custodian?
    end
    def create?
      new?
    end
  end
end
