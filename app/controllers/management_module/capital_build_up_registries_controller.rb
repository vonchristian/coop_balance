module ManagementModule
  class CapitalBuildUpRegistriesController < ApplicationController
    def create
      @registry = Registries::CapitalBuildUpRegistry.create(registry_params)
      if @registry.save
        redirect_to management_module_settings_url, notice: "Capital build up registry saved successfully"
        @registry.parse_for_records
      else
        render :new
      end
    end

    private
    def registry_params
      params.require(:registries_capital_build_up_registry).permit(:spreadsheet, :employee_id)
    end
  end
end

