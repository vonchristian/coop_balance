module LoansModule
  module LoanProducts
    class LoansController < ApplicationController
      def index
        @loan_product = current_cooperative.loan_products.find(params[:loan_product_id])
        @loans = @loan_product.loans.all.paginate(page: params[:page], per_page: 50)
      end
    end
  end
end
