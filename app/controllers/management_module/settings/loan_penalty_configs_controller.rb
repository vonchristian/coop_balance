module ManagementModule
  module Settings 
    class LoanPenaltyConfigsController < ApplicationController 
      def new 
        @loan_penalty_config = CoopConfigurationsModule::LoanPenaltyConfig.new 
      end 
      def create 
        @loan_penalty_config = CoopConfigurationsModule::LoanPenaltyConfig.create(loan_penalty_config_params)
        if @loan_penalty_config.valid?
          @loan_penalty_config.save 
          redirect_to management_module_settings_url, notice: "Loan Penalty Configuration created successfully."
        else 
          render :new 
        end 
      end 

      private 
      def loan_penalty_config_params
        params.require(:coop_configurations_module_loan_penalty_config).permit(:number_of_days, :interest_rate)
      end 
    end 
  end 
end 