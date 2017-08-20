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
      @loan_product = LoansModule::LoanProduct.find(params[:id])
    end

    private 
    def loan_product_params
      params.require(:loans_module_loan_product).permit(:name, :description, :interest_rate, :interest_rate, :mode_of_payment, :max_loanable_amount)
    end
  end
end
