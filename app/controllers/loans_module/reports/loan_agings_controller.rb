module LoansModule
  module Reports
    class LoanAgingsController < ApplicationController
      def index
        @loans              = current_office.loans
        @loan_aging_groups  = current_office.loan_aging_groups.order(start_num: :asc)
        respond_to do |format|
          format.html
          format.xlsx
        end
      end
    end
  end
end
