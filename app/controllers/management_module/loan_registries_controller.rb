module ManagementModule
  class LoanRegistriesController < ApplicationController
    def create
      @registry = Registries::LoanRegistry.create(registry_params)
      if @registry.save
        redirect_to management_module_settings_url, notice: "Loans uploaded successfully."
        @registry.parse_for_records
      else
        render :new
      end
    end

    private
    def registry_params
      params.require(:registries_loan_registry).permit(:spreadsheet, :employee_id)
    end
  end
end

