module LoansModule
  module Loans
    class PaymentFromSavingProcessingsController < ApplicationController
      def new
        @loan            = current_office.loans.find(params[:loan_id])
        @saving          = current_office.savings.find(params[:saving_id])
        @payment         = LoansModule::Loans::PaymentFromSaving.new
      end

      def create
        @loan    = current_office.loans.find(params[:loan_id])
        @saving  = current_office.savings.find(params[:loans_module_loans_payment_from_saving][:saving_id])
        @payment = LoansModule::Loans::PaymentFromSaving.new(payment_params)
        if @payment.valid?
          @payment.process!
          redirect_to new_loans_module_loan_payment_from_saving_url(@loan), notice: "Amount created successfully"
        else
          render :new, status: :unprocessable_entity
        end
      end

      def destroy
        @loan = current_office.loans.find(params[:loan_id])
        @amount = current_cart.voucher_amounts.find(params[:id])
        @amount.destroy
        redirect_to new_loans_module_loan_payment_from_saving_url(@loan), alert: "Removed successfully"
      end

      private

      def payment_params
        params.require(:loans_module_loans_payment_from_saving)
              .permit(:amount, :loan_id, :saving_id, :cart_id, :employee_id)
      end
    end
  end
end
