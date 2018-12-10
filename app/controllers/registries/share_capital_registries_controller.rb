module Registries
  class ShareCapitalRegistriesController < ApplicationController
    def create
      @registry = current_cooperative.share_capital_registries.create!(registry_params)
      @registry.save
      @registry.parse_for_records
      # disable turbolinks on redirects
      redirect_to management_module_settings_data_migrations_url, notice: "Share Capital registry saved successfully"
    end

    private
    def registry_params
      params.require(:registries_share_capital_registry).permit(:spreadsheet, :employee_id)
    end
  end
end
