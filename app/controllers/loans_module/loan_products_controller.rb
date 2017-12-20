module LoansModule
  class LoanProductsController < ApplicationController
    def index
      @loan_products = LoansModule::LoanProduct.all
    end
    def new
      @loan_product = LoansModule::LoanProduct.new
    end
    def create
      @loan_product = LoansModule::LoanProduct.create(loan_product_params)
      if @loan_product.valid?
        @loan_product.save
        redirect_to loans_module_loan_products_url, notice: "Loan Product created successfully."
      else
        render :new
      end
    end
    def show
      @loan_product = LoansModule::LoanProduct.friendly.find(params[:id])
    end

    def edit
      @loan_product = LoansModule::LoanProduct.friendly.find(params[:id])
    end
    def update
      @loan_product = LoansModule::LoanProduct.friendly.find(params[:id])
      @loan_product.update(loan_product_params)
      if @loan_product.save
        redirect_to loans_module_loan_product_url(@loan_product), notice: "updated successfully"
      else
        render :edit
      end
    end

    private
    def loan_product_params
      params.require(:loans_module_loan_product).permit(:name, :description, :mode_of_payment, :max_loanable_amount, :account_id, :interest_account_id, :penalty_account_id, :interest_rate)
    end
  end
end
