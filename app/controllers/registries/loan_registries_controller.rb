module Registries
  class LoanRegistriesController < ApplicationController
    def create
      @registry = current_cooperative.loan_registries.create(registry_params)
      if @registry.save
        redirect_to management_module_settings_data_migrations_url, notice: 'Loans uploaded successfully.'
        @registry.parse_for_records
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def registry_params
      params.require(:registries_loan_registry).permit(:spreadsheet, :office_id, :employee_id)
    end
  end
end
