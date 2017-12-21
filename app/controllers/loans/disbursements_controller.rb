module Loans
  class DisbursementsController < ApplicationController
    def index
      @loan = LoansModule::Loan.find(params[:loan_id])
    end

    def new
      @loan = LoansModule::Loan.find(params[:loan_id])
      @disbursement = LoanDisbursementForm.new
    end
    def create
      @loan = LoansModule::Loan.find(params[:loan_id])
      @disbursement = LoanDisbursementForm.new(disbursement_params)
      if @disbursement.valid?
        @disbursement.save
        redirect_to loan_path(@loan), notice: "Disbursed successfully."
      else
        render :new
      end
    end

    private
    def disbursement_params
      params.require(:loan_disbursement_form).permit(:recorder_id, :amount, :loan_id, :reference_number, :date, :payee_id)
    end
  end
end
