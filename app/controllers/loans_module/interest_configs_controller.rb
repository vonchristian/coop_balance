module LoansModule
  class InterestConfigsController < ApplicationController
    def edit
      @interest_config = LoansModule::InterestConfig.find(params[:id])
    end
    def update
      @interest_config = LoansModule::InterestConfig.find(params[:id])
      @interest_config.update(interest_config_params)
      if @interest_config.valid?
        @interest_config.save
        redirect_to loans_module_loan_product_url(@interest_config.loan_product), notice: "Interest Config updated successfully"
      else
        render :edit
      end
    end

    private
    def interest_config_params
      params.require(:loans_module_interest_config).permit(:interest_revenue_account_id, :unearned_interest_income_account_id, :rate)
    end
  end
end
