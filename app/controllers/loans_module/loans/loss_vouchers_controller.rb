module LoansModule
  module Loans
    class LossVouchersController < ApplicationController
      def show
        @loan = current_cooperative.loans.find(params[:loan_id])
      end
    end
  end
end
