module LoansModule
  module Loans
    class PenaltyPostingsController < ApplicationController
      def new
        @loan = LoansModule::Loan.find(params[:loan_id])
        @interest_posting = LoansModule::Loans::PenaltyPosting.new
      end
      def create
        @loan = LoansModule::Loan.find(params[:loan_id])
        @interest_posting = LoansModule::Loans::PenaltyPosting.new(penalty_params)
        if @interest_posting.valid?
          @interest_posting.post!
          redirect_to loan_url(@loan), notice: "Penalty receivable posted successfully."
        else
          render :new
        end
      end

      private
      def penalty_params
        params.require(:loans_module_loans_penalty_posting).
        permit(:date, :reference_number, :description, :amount, :employee_id, :loan_id)
      end
    end
  end
end
