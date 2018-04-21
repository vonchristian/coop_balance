module LoansModule
  class LoanApplicationsController < ApplicationController
    def new
      @loan = LoansModule::LoanApplicationForm.new
    end

    def create
      @loan = LoansModule::LoanApplicationForm.new(loan_params)
      if @loan.valid?
        @loan.save
        redirect_to loans_module_loan_application_url(@loan.find_loan), notice: "Loan application saved successfully."
      else
        render :new
      end
    end
    def show
      @loan = LoansModule::Loan.find(params[:id])
      @borrower = @loan.borrower
    end
    def destroy
      @loan = LoansModule::Loan.find(params[:id])
      @loan.destroy
      redirect_to loans_url, notice: "Loan application cancelled successfully"
    end

    private
    def loan_params
      params.require(:loans_module_loan_application_form).permit(
                  :borrower_id,
                  :borrower_type,
                  :term,
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
