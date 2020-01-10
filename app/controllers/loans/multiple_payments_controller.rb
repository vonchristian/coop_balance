module Loans
  class MultiplePaymentsController < ApplicationController
    def new
      @loan    = current_office.loans.find(params[:loan_id])
      @payment = ::Loans::MultiplePayment.new
    end
    def create
      @loan    = current_office.loans.find(params[:loan_id])
      @payment = ::Loans::MultiplePayment.new(payment_params)
      if @payment.valid?
        @payment.process!
        redirect_to new_loan_multiple_payment_line_item_url, notice: "Payment added successfully."
      else
        render :new
      end
    end

    def destroy 
      @loan = current_office.loans.find(params[:loan_id])
      @amount = current_cart.voucher_amounts.where(account: @loan.accounts).destroy_all
      redirect_to new_loan_multiple_payment_line_item_url, notice: 'removed successfully'
    end 
    private
    def payment_params
      params.require(:loans_multiple_payment).
      permit(:principal_amount, :interest_amount, :penalty_amount, :amortization_schedule_id, :employee_id, :loan_id, :date, :cart_id)
    end

   
  end
end
