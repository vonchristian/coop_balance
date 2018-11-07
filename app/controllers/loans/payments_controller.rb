require 'will_paginate/array'
module Loans
  class PaymentsController < ApplicationController
    def index
      @loan = current_cooperative.loans.find(params[:loan_id])
      @payments = @loan.loan_payments.sort_by(&:entry_date).reverse.paginate(page: params[:page], per_page: 25)
    end
    def new
      @loan = current_cooperative.loans.find(params[:loan_id])
      @payment = LoansModule::Loans::PaymentProcessing.new
    end
    def create
      @loan = current_cooperative.loans.find(params[:loan_id])
      @payment = LoansModule::Loans::PaymentProcessing.new(payment_params)
      if @payment.valid?
        @payment.process!
        redirect_to loan_payment_voucher_url(loan_id: @loan.id, id: @payment.find_voucher.id), notice: "Payment voucher created successfully."
      else
        render :new
      end
    end

    private
    def payment_params
      params.require(:loans_module_loans_payment_processing).
      permit(:principal_amount, :interest_amount, :penalty_amount, :description, :employee_id, :loan_id, :reference_number, :date, :cash_account_id, :account_number)
    end
  end
end
