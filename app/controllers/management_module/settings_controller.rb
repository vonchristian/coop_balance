module ManagementDepartment
  class SettingsController < ApplicationController
    def index
      @share_capital_products = ShareCapitalProduct.joins(:share_capital_product_shares).all
    end
  end
end
