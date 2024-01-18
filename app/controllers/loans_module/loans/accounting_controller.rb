module LoansModule
  module Loans
    class AccountingController < ApplicationController
      def index
        @loan = current_office.loans.find(params[:loan_id])
      end
    end
  end
end
