module LoansModule
  module LoanProducts
    class ReportsController < ApplicationController
      def index
        @loan_product      = current_office.loan_products.find(params[:loan_product_id])
        @loan_aging_groups = current_office.loan_aging_groups 
      end
    end
  end
end
