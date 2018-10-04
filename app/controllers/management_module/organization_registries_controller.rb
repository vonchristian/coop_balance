module ManagementModule
  class OrganizationRegistriesController < ApplicationController
    def create
      @registry = Registries::OrganizationRegistry.create(registry_params)
      if @registry.save
        redirect_to management_module_settings_url, notice: "Organization uploaded successfully."
        @registry.parse_for_records
      else
        render :new
      end
    end

    private
    def registry_params
      params.require(:registries_organization_registry).permit(:spreadsheet, :employee_id)
    end
  end
end

