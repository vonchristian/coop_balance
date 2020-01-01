require 'will_paginate/array'
module Loans
  class PaymentsController < ApplicationController
    def index
      @loan      = current_office.loans.find(params[:loan_id])
      @payments  = @loan.loan_payments.sort_by(&:entry_date).reverse.uniq.paginate(page: params[:page], per_page: 25)
      @from_date = params[:from_date] ? Date.parse(params[:from_date]) : @loan.entries.order(entry_date: :desc).first.entry_date
      @to_date   = params[:to_date] ? Date.parse(params[:to_date]) : @loan.last_transaction_date

      respond_to do |format|
        format.pdf do 
          pdf = StatementOfAccounts::LoanPdf.new(
            loan:         @loan,
            from_date:    @from_date, 
            to_date:      @to_date,
            view_context: view_context
          )
          send_data pdf.render, type: 'application/pdf', disposition: 'inline', file_name: "#{@loan.borrower_name} Loan Statement.pdf"
        end
        format.html
      end
    end
    def new
      @loan    = current_office.loans.find(params[:loan_id])
      @payment = @loan.payment_processor.new
    end
    def create
      @loan = current_office.loans.find(params[:loan_id])
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
