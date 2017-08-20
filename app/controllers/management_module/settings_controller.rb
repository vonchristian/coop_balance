module ManagementModule
  class SettingsController < ApplicationController
    def index
      @share_capital_products = CoopServicesModule::ShareCapitalProduct.joins(:share_capital_product_shares).all
    end
  end
end
