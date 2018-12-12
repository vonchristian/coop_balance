module LoansModule
  module LoanProducts
    class ReportsController < ApplicationController
      def index
        @loan_product = current_cooperative.loan_products.find(params[:loan_product_id])
      end
    end
  end
end
