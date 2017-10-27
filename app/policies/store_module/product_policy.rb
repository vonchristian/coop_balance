module StoreModule 
  class ProductPolicy < ApplicationPolicy
    def new?
      user.stock_custodian? || user.sales_clerk?
    end 
    def create?
      new?
    end 
  end 
end 