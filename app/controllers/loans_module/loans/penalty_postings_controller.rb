module LoansModule
  module Loans
    class PenaltyPostingsController < ApplicationController
      respond_to :html, :json

      def new
        @loan = LoansModule::Loan.find(params[:loan_id])
        @penalty_posting = LoansModule::Loans::PenaltyPosting.new
        respond_modal_with @penalty_posting
      end

      def create
        @loan = LoansModule::Loan.find(params[:loan_id])
        @penalty_posting = LoansModule::Loans::PenaltyPosting.new(penalty_params)
        @penalty_posting.post!
        respond_modal_with @penalty_posting, location: loan_url(@loan), notice: "Penalty receivable posted successfully."
        # if @penalty_posting.valid?
        #   @penalty_posting.post!
        #   redirect_to loan_url(@loan), notice: "Penalty receivable posted successfully."
        # else
        #   render :new
        # end
      end

      private
      def penalty_params
        params.require(:loans_module_loans_penalty_posting).
        permit(:date, :description, :amount, :employee_id, :loan_id)
      end
    end
  end
end
