require 'will_paginate/array'
module Loans
  class PaymentsController < ApplicationController
    def index
      @loan = current_cooperative.loans.find(params[:loan_id])
      @payments = @loan.loan_payments.sort_by(&:entry_date).reverse.paginate(page: params[:page], per_page: 25)
    end
    def new
      @loan = current_cooperative.loans.find(params[:loan_id])
      @payment = @loan.payment_processor.new
    end
    def create
      @loan = current_cooperative.loans.find(params[:loan_id])
      @payment = @loan.payment_processor.new(payment_params)
      if @payment.valid?
        @payment.process!
        redirect_to loan_payment_voucher_url(schedule_id: @payment.schedule_id, loan_id: @loan.id, id: @payment.find_voucher.id), notice: "Payment voucher created successfully."
      else
        render :new
      end
    end

    private
    
    def payment_params
      params.require(payment_processor_params).
      permit(:principal_amount, :interest_amount, :penalty_amount, :amortization_schedule_id, :description, :employee_id, :loan_id, :reference_number, :date, :cash_account_id, :account_number)
    end

    def payment_processor_params
      @loan.payment_processor.to_s.underscore.gsub("/", "_").to_sym
    end
  end
end
