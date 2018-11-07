module LoansModule
  module Loans
    class InterestPostingsController < ApplicationController
      respond_to :html, :json

      def new
        @loan = current_cooperative.loans.find(params[:loan_id])
        @interest_posting = LoansModule::Loans::InterestPosting.new
        respond_modal_with @interest_posting
      end

      def create
        @loan = current_cooperative.loans.find(params[:loan_id])
        @interest_posting = LoansModule::Loans::InterestPosting.new(interest_params)
        @interest_posting.post!
        respond_modal_with @interest_posting, location: loan_url(@loan), notice: "Interest receivable posted successfully."
      end

      private
      def interest_params
        params.require(:loans_module_loans_interest_posting).
        permit(:date, :description, :amount, :employee_id, :loan_id)
      end
    end
  end
end
