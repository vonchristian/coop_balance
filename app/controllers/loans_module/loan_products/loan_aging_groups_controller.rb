module LoansModule
  module LoanProducts 
    class LoanAgingGroupsController < ApplicationController
      def index 
      end 

      def show 
        @loan_product     = current_office.loan_products.find(params[:id])
        @loan_aging_group = current_office.loan_aging_groups.find(params[:loan_aging_group_id])
        @pagy, @loans     = pagy(@loan_aging_group.loans.where(loan_product: @loan_product))
      end 
    end 
  end 
end 