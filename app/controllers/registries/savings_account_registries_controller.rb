module Registries
  class SavingsAccountRegistriesController < ApplicationController
    def create
      @registry = current_cooperative.savings_account_registries.create(registry_params)
      if @registry.save
        redirect_to management_module_settings_data_migrations_url, notice: "Savings Account registry saved successfully"
        @registry.parse_for_records
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def registry_params
      params.require(:registries_savings_account_registry).permit(:spreadsheet, :employee_id, :office_id)
    end
  end
end
