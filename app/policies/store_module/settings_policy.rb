module StoreModule
  class SettingsPolicy < ApplicationPolicy
    def index?
      user.sales_clerk?
    end
    def new?
      user.sales_clerk?
    end
    def create?
      new?
    end
  end
end
