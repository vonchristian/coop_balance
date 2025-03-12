module AccountingModule
  class LoanProductsController < ApplicationController
    def show
      @loan_product = current_office.loan_products.find(params[:id])
      @pagy, @loans = pagy(current_office.loans.where(loan_product: @loan_product))
    end
  end
end
