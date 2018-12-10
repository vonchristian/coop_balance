module Registries
  class TimeDepositRegistriesController < ApplicationController
    def create
      @registry = current_cooperative.time_deposit_registries.create(registry_params)
      if @registry.save
        redirect_to management_module_settings_data_migrations_url, notice: "Time Deposits uploaded successfully."
        @registry.parse_for_records
      else
        render :new
      end
    end

    private
    def registry_params
      params.require(:registries_time_deposit_registry).permit(:spreadsheet, :employee_id)
    end
  end
end
