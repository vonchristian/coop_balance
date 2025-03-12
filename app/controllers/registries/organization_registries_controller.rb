module Registries
  class OrganizationRegistriesController < ApplicationController
    def create
      @registry = current_cooperative.organization_registries.create(registry_params)
      if @registry.save
        redirect_to management_module_settings_data_migrations_url, notice: "Organizations uploaded successfully."
        @registry.parse_for_records
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def registry_params
      params.require(:registries_organization_registry).permit(:spreadsheet, :employee_id)
    end
  end
end
