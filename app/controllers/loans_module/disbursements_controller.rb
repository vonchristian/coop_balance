module LoansModule
  class DisbursementsController < ApplicationController
    def new
      @loan = LoansModule::Loan.find(params[:loan_id])
      @disbursement = LoanDisbursementForm.new
    end
    def create
      @loan = LoansModule::Loan.find(params[:loan_id])
      @disbursement = LoanDisbursementForm.new(disbursement_params)
      if @disbursement.valid?
        @disbursement.save
        redirect_to loans_department_loan_path(@loan), notice: "Disbursed successfully."
      else
        render :new
      end
    end

    private
    def disbursement_params
      params.require(:loan_disbursement_form).permit(:amount, :loan_id, :reference_number, :date)
    end
  end
end
