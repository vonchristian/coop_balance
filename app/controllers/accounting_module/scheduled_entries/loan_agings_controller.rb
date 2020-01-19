module AccountingModule
  module ScheduledEntries 
    class LoanAgingsController < ApplicationController
      def index 
        @loan_products = current_office.loan_products
      end 
    end 
  end 
end 