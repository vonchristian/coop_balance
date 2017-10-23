module ManagementModule
  class SettingsController < ApplicationController
    def index
      @cooperative = current_user.cooperative
      @share_capital_products = CoopServicesModule::ShareCapitalProduct.joins(:share_capital_product_shares).all
    end
  end
end
