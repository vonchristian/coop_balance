module LoansModule
  module Loans
    class RestructureVouchersController < ApplicationController
      def new
        @loan = current_cooperative.loans.find(params[:loan_id])
        @restructuring = LoansModule::Loans::Restructuring.new
      end
    end
  end
end
