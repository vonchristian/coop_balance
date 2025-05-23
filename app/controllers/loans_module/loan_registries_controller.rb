module LoansModule
  class LoanRegistriesController < ApplicationController
    def create
      @loan_registry = current_cooperative.loan_registries.create(registry_params)
      return unless @loan_registry.valid?

      @loan_registry.save
      @loan_registry.parse_for_records
      redirect_to loans_module_settings_url, notice: "Registry uploaded successfully"
    end

    private

    def registry_params
      params.require(:loans_module_loan_registry).permit(:spreadsheet, :office_id, :employee_id)
    end
  end
end
