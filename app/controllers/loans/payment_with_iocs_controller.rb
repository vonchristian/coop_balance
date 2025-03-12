require "will_paginate/array"
module Loans
  class PaymentWithIocsController < ApplicationController
    def new
      @loan = current_cooperative.loans.find(params[:loan_id])
      @payment = LoansModule::Loans::PaymentWithIocProcessing.new
    end

    def create
      @loan = current_cooperative.loans.find(params[:loan_id])
      @payment = LoansModule::Loans::PaymentWithIocProcessing.new(payment_params)
      if @payment.valid?
        @payment.process!
        redirect_to loan_payment_voucher_url(schedule_id: @payment.schedule_id, loan_id: @loan.id, id: @payment.find_voucher.id), notice: "Payment voucher created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def payment_params
      params.require(:loans_module_loans_payment_with_ioc_processing)
            .permit(
              :principal_amount,
              :interest_amount,
              :penalty_amount,
              :amortization_schedule_id,
              :description,
              :employee_id,
              :loan_id,
              :share_capital_id,
              :reference_number,
              :date,
              :cash_account_id,
              :account_number
            )
    end
  end
end
