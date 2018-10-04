module ManagementModule
  class MemberRegistriesController < ApplicationController
    def create
      @registry = Registries::MemberRegistry.create(registry_params)
      if @registry.save
        redirect_to management_module_settings_url, notice: "Member uploaded successfully."
        @registry.parse_for_records
      else
        render :new
      end
    end

    private
    def registry_params
      params.require(:registries_member_registry).permit(:spreadsheet, :employee_id)
    end
  end
end