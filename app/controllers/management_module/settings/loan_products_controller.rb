module ManagementModule
  module Settings
    class LoanProductsController < ApplicationController

      def index
        @loan_products = LoansModule::LoanProduct.all
      end

      def new
        @loan_product = LoansModule::LoanProductRegistration.new 
      end

      def create
        @loan_product = LoansModule::LoanProductRegistration.new(loan_product_params)
        if @loan_product.valid?
          @loan_product.register!
          redirect_to management_module_settings_cooperative_products_url, notice: "Loan product created successfully."
        else
          render :new
        end
      end

      def edit
        @loan_product = current_cooperative.loan_products.find(params[:id])
        @loan_product_form = LoansModule::LoanProductRegistration.new("id" => @loan_product.id)
        respond_modal_with @loan_product_form
      end

      def update
        @loan_product = current_cooperative.loan_products.find(params[:id])
        @loan_product_form = LoansModule::LoanProductRegistration.new(loan_product_params.merge("id" => params[:id]))
        @loan_product_form.update!
        respond_modal_with @loan_product_form,
          location: management_module_settings_cooperative_products_url
      end

      private
      def loan_product_params
        params.require(:loans_module_loan_product_registration).permit(
        :name,
        :description,
        :maximum_loanable_amount,
        
        :interest_rate,
        :interest_revenue_account_id,
        :unearned_interest_income_account_id,
        :penalty_rate,
        :penalty_revenue_account_id,
        :loan_protection_plan_provider_id,
        :cooperative_id,
        :grace_period,
        :amortization_type_id,
        :interest_amortization_id,
        :total_repayment_amortization_id,


        :interest_calculation_type,
        :prededuction_calculation_type,
        :prededuction_scope,
        :prededucted_rate,
        :prededucted_amount,
        :office_id,
        :prededucted_number_of_payments)
      end
    end
  end
end
