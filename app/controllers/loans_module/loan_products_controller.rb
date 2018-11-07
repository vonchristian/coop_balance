module LoansModule
  class LoanProductsController < ApplicationController
    def index
      @loan_products = current_cooperative.loan_products
    end
    def new
      @loan_product = LoansModule::LoanProductRegistration.new
    end
    def create
      @loan_product = LoansModule::LoanProductRegistration.new(loan_product_params)
      if @loan_product.valid?
        @loan_product.register!
        redirect_to loans_module_loan_products_url, notice: "Loan Product created successfully."
      else
        render :new
      end
    end
    def show
      @loan_product = current_cooperative.loan_products.find(params[:id])
    end

    def edit
      @loan_product = current_cooperative.loan_products.find(params[:id])
    end

    def update
      @loan_product = current_cooperative.loan_products.find(params[:id])
      @loan_product.update(loan_product_params)
      if @loan_product.save
        redirect_to loans_module_loan_product_url(@loan_product), notice: "updated successfully"
      else
        render :edit
      end
    end

    private
    def loan_product_params
      params.require(:loans_module_loan_product_registration).
      permit(:name,
      :description,
      :maximum_loanable_amount,
      :loans_receivable_current_account_id,
      :loans_receivable_past_due_account_id,
      :interest_rate,
      :interest_revenue_account_id,
      :unearned_interest_income_account_id,
      :penalty_rate,
      :penalty_revenue_account_id,
      :has_loan_protection_fund)
    end
  end
end
