module Registries
  class BankAccountRegistriesController < ApplicationController
    def create
      @registry = current_cooperative.bank_account_registries.create(registry_params)
      if @registry.save
        redirect_to management_module_settings_data_migrations_url, notice: "Bank Accounts saved successfully"
        @registry.parse_for_records
      else
        render :new, status: :unprocessable_entity
      end
    end
    private
    def registry_params
      params.require(:registries_bank_account_registry).permit(:spreadsheet, :employee_id)
    end
  end
end
