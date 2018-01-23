module LoansModule
  class InterestConfigurationsController < ApplicationController
    def new
      @loan_product = LoansModule::LoanProduct.friendly.find(params[:loan_product_id])
      @interest_configuration = @loan_product.build_interest_config
    end
    def create
      @loan_product = LoansModule::LoanProduct.friendly.find(params[:loan_product_id])
      @interest_configuration = @loan_product.create_interest_config(interest_config_params)
      if @interest_configuration.valid?
        @interest_configuration.save
        redirect_to loans_module_loan_product_url(@loan_product), notice: "Interest Configuration saved successfully."
      else
        render :new
      end
    end
    private
    def interest_config_params
      params.require(:loans_module_interest_config).permit(:interest_revenue_account_id, :unearned_interest_income_account_id, :rate)
    end
  end
end
