module ManagementModule
  class ShareCapitalRegistriesController < ApplicationController
    def create
      @registry = Registries::ShareCapitalRegistry.create(registry_params)
      if @registry.save
        redirect_to management_module_settings_data_migrations_url, notice: "Share Capital registry saved successfully"
        @registry.parse_for_records
      else
        render :new
      end
    end

    private
    def registry_params
      params.require(:registries_share_capital_registry).permit(:spreadsheet, :employee_id)
    end
  end
end

