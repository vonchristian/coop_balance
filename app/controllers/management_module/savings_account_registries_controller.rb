module ManagementModule
  class SavingsAccountRegistriesController < ApplicationController
    def create
      @registry = Registries::SavingsAccountRegistry.create(registry_params)
      if @registry.save
        redirect_to management_module_settings_url, notice: "Savings Account registry saved successfully"
        @registry.parse_for_records
      else
        render :new
      end
    end

    private
    def registry_params
      params.require(:registries_savings_account_registry).permit(:spreadsheet, :employee_id)
    end
  end
end
