module LoansModule
  module Loans
    class LoanPenaltyDiscountsController < ApplicationController
      respond_to :html, :json

      def new
        @loan = current_cooperative.loans.find(params[:loan_id])
        @loan_discount = @loan.loan_discounts.penalty.build
        respond_modal_with @loan_discount
      end

      def create
        @loan = current_cooperative.loans.find(params[:loan_id])
        @loan_discount = @loan.loan_discounts.penalty.create(loan_discount_params)
        respond_modal_with @loan_discount, location: loan_url(@loan), notice: "Loan penalty discount saved successfully."
        # if @loan_discount.valid?
        #   @loan_discount.save
        #   redirect_to loan_url(@loan), notice: "Loan penalty discount saved successfully."
        # else
        #   render :new
        # end
      end

      private
      def loan_discount_params
        params.require(:loans_module_loans_loan_discount).
        permit(:date, :amount, :description)
      end
    end
  end
end

