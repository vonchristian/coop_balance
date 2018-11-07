module ManagementModule
  class SettingsController < ApplicationController
    def index
      @cooperative = current_cooperative
      @share_capital_products = current_cooperative.share_capital_products
      @time_deposit_products = current_cooperative.time_deposit_products
      @programs = current_cooperative.programs
      @savings_registry = Registries::SavingsAccountRegistry.new
    end
  end
end
