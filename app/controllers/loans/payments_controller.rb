module Loans
  class PaymentsController < ApplicationController
    def index
      @loan = LoansModule::Loan.find(params[:loan_id])
    end
    def new
      @loan = LoansModule::Loan.find(params[:loan_id])
      @payment = LoanPaymentForm.new
    end
    def create
      @loan = LoansModule::Loan.find(params[:loan_id])
      @payment = LoanPaymentForm.new(payment_params)
      if @payment.valid?
        @payment.save
        redirect_to loan_payments_path(@loan), notice: "Loan payment saved successfully."
      else
        render :new
      end
    end

    private
    def payment_params
      params.require(:loan_payment_form).
      permit(:principal_amount, :interest_amount, :penalty_amount, :recorder_id, :loan_id, :reference_number, :date)
    end
  end
end
