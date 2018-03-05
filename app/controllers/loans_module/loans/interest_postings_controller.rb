module LoansModule
  module Loans
    class InterestPostingsController < ApplicationController
      def new
        @loan = LoansModule::Loan.find(params[:loan_id])
        @interest_posting = LoansModule::Loans::InterestPosting.new
      end
      def create
        @loan = LoansModule::Loan.find(params[:loan_id])
        @interest = LoansModule::Loans::InterestPosting.new(interest_params)
        if @interest_posting.valid?
          @interest_posting.post!
        else
          render :new
        end
      end

      private
      def interest_params
        params.require(:loans_module_loans_interest_posting).
        permit(:date, :reference_number, :description, :amount, :recorder_id, :loan_id)
      end
    end
  end
end
