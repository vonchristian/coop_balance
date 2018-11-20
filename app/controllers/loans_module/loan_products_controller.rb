module LoansModule
  class LoanProductsController < ApplicationController
    
    def index
      @loan_products = current_cooperative.loan_products
    end

    def show
      @loan_product = current_cooperative.loan_products.find(params[:id])
    end
  end
end
