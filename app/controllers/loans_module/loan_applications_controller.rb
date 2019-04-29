module LoansModule
  class LoanApplicationsController < ApplicationController
    require 'will_paginate/array'
    def index
      if params[:search].present?
        @loan_applications = current_office.
        loan_applications.
        not_cancelled.
        not_approved.
        text_search(params[:search]).
        paginate(page: params[:page], per_page: 20)
      else
        @loan_applications = current_office.
        loan_applications.
        not_cancelled.
        not_approved.
        includes(:loan_product, :voucher =>[:accounting_entry]).
        sort_by(&:ascending_order).
        paginate(page: params[:page], per_page: 20)
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
        render :new
      end
    end
    def show
      @loan_application = current_cooperative.loan_applications.find(params[:id])
    end

    def destroy
      @loan_application = current_cooperative.loan_applications.find(params[:id])
      @loan_application.destroy
      redirect_to loans_url, notice: "Loan application cancelled successfully"
    end

    private
    def loan_params
      params.require(:loans_module_loan_application_processing).permit(
                  :cooperative_id,
                  :borrower_id,
                  :borrower_type,
                  :term,
                  :purpose,
                  :loan_product_id,
                  :loan_amount,
                  :application_date,
                  :mode_of_payment,
                  :application_date,
                  :account_number,
                  :preparer_id)
    end
  end
end
