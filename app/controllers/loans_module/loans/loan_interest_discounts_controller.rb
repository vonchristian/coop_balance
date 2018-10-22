module LoansModule
  module Loans
    class LoanInterestDiscountsController < ApplicationController
      respond_to :html, :json

      def new
        @loan = LoansModule::Loan.find(params[:loan_id])
        @loan_discount = @loan.loan_discounts.interest.build
        respond_modal_with @loan_discount
      end

      def create
        @loan = LoansModule::Loan.find(params[:loan_id])
        @loan_discount = @loan.loan_discounts.interest.create(loan_discount_params)
        respond_modal_with @loan_discount, location: loan_url(@loan), notice: "Loan interest discount saved successfully."
      end

      private
      def loan_discount_params
        params.require(:loans_module_loans_loan_discount).
        permit(:date, :amount, :description)
      end
    end
  end
end

