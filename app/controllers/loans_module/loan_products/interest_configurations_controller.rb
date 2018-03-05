module LoansModule
  module LoanProducts
    class InterestConfigurationsController < ApplicationController
      def new
        @loan_product = LoansModule::LoanProduct.find(params[:loan_product_id])
        @interest_configuration = @loan_product.interest_configs.build
      end
      def create
        @loan_product = LoansModule::LoanProduct.find(params[:loan_product_id])
        @interest_configuration = @loan_product.interest_configs.create(interest_configuration_params)
        if @interest_configuration.valid?
          @interest_configuration.save
          redirect_to loans_module_loan_product_url(@loan_product), notice: "Interest Configuration saved successfully"
        else
          render :new
        end
      end

      private
      def interest_configuration_params
        params.require(:loans_module_loan_products_interest_config).
        permit(:rate, :interest_revenue_account_id, :unearned_interest_income_account_id, :interest_receivable_account_id)
      end
    end
  end
end