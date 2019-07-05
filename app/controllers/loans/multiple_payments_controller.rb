module Loans
  class MultiplePaymentsController < ApplicationController
    def new
      @loan    = current_office.loans.find(params[:loan_id])
      @payment = ::Loans::MultiplePayment.new
    end
    def create
      @loan    = current_cooperative.loans.find(params[:loan_id])
      @payment = ::Loans::MultiplePayment.new(payment_params)
      if @payment.valid?
        @payment.create_payment_voucher!
        redirect_to new_loan_multiple_payment_line_item_url, notice: "Payment created successfully."
      else
        render :new
      end
    end

    private
    def payment_params
      params.require(:loans_multiple_payment).
      permit(:principal_amount, :interest_amount, :penalty_amount, :amortization_schedule_id, :description, :employee_id, :loan_id, :reference_number, :date, :cash_account_id, :cart_id)
    end
  end
end
