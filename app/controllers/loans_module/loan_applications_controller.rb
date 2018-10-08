module LoansModule
  class LoanApplicationsController < ApplicationController
    def new
      @borrower = Borrower.find(params[:borrower_id])
      @loan = LoansModule::LoanApplicationProcessing.new
    end

    def create
      @borrower = Borrower.find(params[:loans_module_loan_application_processing][:borrower_id])
      @loan = LoansModule::LoanApplicationProcessing.new(loan_params)
      if @loan.valid?
        @loan.save
        redirect_to loans_module_loan_application_url(@loan.find_loan), notice: "Loan application saved successfully."
      else
        render :new
      end
    end
    def show
      @loan_application = LoansModule::LoanApplication.find(params[:id])
      @borrower = @loan_application.borrower
      @voucher = LoansModule::Loans::DisbursementVoucher.new
    end

    def destroy
      @loan_application = LoansModule::LoanApplication.find(params[:id])
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
