module ManagementModule
  module Settings
    class SavingsAccountConfigsController < ApplicationController
      def new
        @savings_account_config = CoopConfigurationsModule::SavingsAccountConfig.new
      end
      def create
        @savings_account_config = CoopConfigurationsModule::SavingsAccountConfig.create(config_params)
        if @savings_account_config.save
          redirect_to management_module_settings_url, notice: "Savings Configuration saved successfully."
        else
          render :new
        end
      end

      private
      def config_params
        params.require(:coop_configurations_module_savings_account_config).permit(:closing_account_fee, :closing_account_id, :interest_account_id)
      end
    end
  end
end
