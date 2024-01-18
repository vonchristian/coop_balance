module LoansModule
  module Loans
    class PaymentFromShareCapitalProcessingsController < ApplicationController
      def new
        @loan            = current_office.loans.find(params[:loan_id])
        @share_capital   = current_office.share_capitals.find(params[:share_capital_id])
        @payment         = LoansModule::Loans::PaymentFromShareCapital.new
      end

      def create
        @loan          = current_office.loans.find(params[:loan_id])
        @share_capital = current_office.share_capitals.find(params[:loans_module_loans_payment_from_share_capital][:share_capital_id])
        @payment       = LoansModule::Loans::PaymentFromShareCapital.new(payment_params)
        if @payment.valid?
          @payment.process!
          redirect_to new_loans_module_loan_payment_from_share_capital_url(@loan), notice: 'Amount created successfully'
        else
          render :new, status: :unprocessable_entity
        end
      end

      def destroy
        @loan = current_office.loans.find(params[:loan_id])
        @amount = current_cart.voucher_amounts.find(params[:id])
        @amount.destroy
        redirect_to new_loans_module_loan_payment_from_share_capital_url(@loan), alert: 'Removed successfully'
      end

      private

      def payment_params
        params.require(:loans_module_loans_payment_from_share_capital)
              .permit(:amount, :loan_id, :share_capital_id, :cart_id, :employee_id)
      end
    end
  end
end
