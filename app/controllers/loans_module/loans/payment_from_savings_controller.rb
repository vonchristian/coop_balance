module LoansModule
  module Loans
    class PaymentFromSavingsController < ApplicationController
      def new
        @loan             = current_office.loans.find(params[:loan_id])
        @borrower_savings = @loan.borrower.savings
        @payment_voucher  = LoansModule::Loans::PaymentVoucher.new
        if params[:search].present?
          @pagy, @savings = pagy(current_office.savings.text_search(params[:search]))
        else
          @pagy, @savings = pagy(current_office.savings.where.not(id: @borrower_savings.ids))
        end
      end
    end
  end
end
