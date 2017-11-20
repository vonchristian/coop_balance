module ManagementModule
  class SavingsAccountRegistriesController < ApplicationController
    def create
      @registry = Registries::SavingsAccountRegistry.create(registry_params)
      if @registry.save
        redirect_to management_module_settings_url, notice: "Savings Account registry saved successfully"
      else
        render :new
      end
    end

    private
    def registry_params
      params.require(:registry).permit(:spreadsheet, :employee_id)
    end
  end
end
