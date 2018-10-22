module ManagementModule
  module Settings
    class SavingsAccountConfigsController < ApplicationController
      respond_to :html, :json

      def new
        @savings_account_config = CoopConfigurationsModule::SavingsAccountConfig.new
        respond_modal_with @savings_account_config
      end
      
      def create
        @savings_account_config = CoopConfigurationsModule::SavingsAccountConfig.create(config_params)
        respond_modal_with @savings_account_config, 
          location: management_module_settings_configurations_url, 
          notice: "Savings Configuration saved successfully."
      end

      private
      def config_params
        params.require(:coop_configurations_module_savings_account_config).permit(:closing_account_fee, :number_of_days_to_be_dormant, :closing_account_id, :interest_expense_account_id)
      end
    end
  end
end
