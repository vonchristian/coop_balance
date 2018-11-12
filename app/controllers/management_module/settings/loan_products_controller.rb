module ManagementModule
  module Settings
    class LoanProductsController < ApplicationController
      respond_to :html, :json

      def index
        @loan_products = LoansModule::LoanProduct.all
      end

      def new
        @loan_product = LoansModule::LoanProductRegistration.new
        respond_modal_with @loan_product
      end

      def create
        @loan_product = LoansModule::LoanProductRegistration.new(loan_product_params)
        @loan_product.register!
        respond_modal_with @loan_product,
          location: management_module_settings_cooperative_products_url
      end

      private
      def loan_product_params
        params.require(:loans_module_loan_product_registration).permit(
        :name,
        :description,
        :maximum_loanable_amount,
        :loans_receivable_current_account_id,
        :loans_receivable_past_due_account_id,
        :interest_rate,
        :interest_revenue_account_id,
        :unearned_interest_income_account_id,
        :penalty_rate,
        :penalty_revenue_account_id,
        :cooperative_id)
      end
    end
  end
end