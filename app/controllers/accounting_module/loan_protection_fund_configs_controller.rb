module AccountingModule
  class LoanProtectionFundConfigsController < ApplicationController
    def new
      @loan_protection_fund_config = CoopConfigurationsModule::LoanProtectionFundConfig.new
    end
    def create
      @loan_protection_fund_config = CoopConfigurationsModule::LoanProtectionFundConfig.create(config_params)
      if @loan_protection_fund_config.save
        redirect_to accounting_module_settings_url, notice: 'saved successfully'
      else
        render :new
      end
    end

    private
    def config_params
      params.require(:coop_configurations_module_loan_protection_fund_config).permit(:account_id)
    end
  end
end
