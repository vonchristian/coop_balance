module LoansModule
  module Loans
    class LossesController < ApplicationController
      def new
        @loan = LoansModule::Loan.find(params[:loan_id])
        @loss = LoansModule::Loans::LossProcessing.new
      end
    end
  end
end
