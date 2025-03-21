module LoansModule
  class LoanApplicationsController < ApplicationController
    require "will_paginate/array"
    def index
      if params[:search].present?
        @pagy, @loan_applications = pagy(current_office
        .loan_applications
        .not_cancelled
        .text_search(params[:search]))

      else
        @pagy, @loan_applications = pagy(current_office
        .loan_applications
        .not_cancelled
        .includes(:loan_product, voucher: [ :accounting_entry ])
        .order(application_date: :desc))
      end
    end

    def new
      @borrower = Borrower.find(params[:borrower_id])
      @loan_application = LoansModule::LoanApplicationProcessing.new
    end

    def create
      @borrower = Borrower.find(params[:loans_module_loan_application_processing][:borrower_id])
      @loan_application = LoansModule::LoanApplicationProcessing.new(loan_params)
      if @loan_application.valid?
        @loan_application.process!
        redirect_to new_loans_module_loan_application_voucher_url(@loan_application.find_loan_application), notice: "Loan application saved successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def show
      @loan_application = current_cooperative.loan_applications.find(params[:id])
    end

    def destroy
      @loan_application = current_cooperative.loan_applications.find(params[:id])
      ::LoansModule::LoanApplications::Cancellation.new(loan_application: @loan_application).cancel!
      redirect_to loans_url, notice: "Loan application cancelled successfully"
    end

    private

    def loan_params
      params.require(:loans_module_loan_application_processing).permit(
        :cooperative_id,
        :borrower_id,
        :borrower_type,
        :number_of_days,
        :purpose,
        :loan_product_id,
        :loan_amount,
        :application_date,
        :mode_of_payment,
        :application_date,
        :account_number,
        :preparer_id
      )
    end
  end
end
