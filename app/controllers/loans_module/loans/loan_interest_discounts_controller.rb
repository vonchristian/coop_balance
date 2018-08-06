module LoansModule
  module Loans
    class LoanInterestDiscountsController < ApplicationController
      def new
        @loan = LoansModule::Loan.find(params[:loan_id])
        @loan_discount = @loan.loan_discounts.interest.build
      end

      def create
        @loan = LoansModule::Loan.find(params[:loan_id])
        @loan_discount = @loan.loan_discounts.interest.create(loan_discount_params)
        if @loan_discount.valid?
          @loan_discount.save
          redirect_to loan_url(@loan), notice: "Loan interest discount saved successfully."
        else
          render :new
        end
      end

      private
      def loan_discount_params
        params.require(:loans_module_loans_loan_discount).
        permit(:date, :amount, :description)
      end
    end
  end
end

