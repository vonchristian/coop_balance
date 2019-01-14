module LoansModule
  class LoanApplicationsController < ApplicationController
    def index
      if params[:search].present?
        @ordered_loan_applications = current_cooperative.loan_applications.where(approved: false, cancelled: false).text_search(params[:search])
        @loan_applications = @ordered_loan_applications.paginate(page: params[:page], per_page: 20)
      else
        @ordered_loan_applications = current_cooperative.loan_applications.where(approved: false, cancelled: false).includes(:voucher).order("vouchers.reference_number DESC", "vouchers.date DESC")
        @loan_applications = @ordered_loan_applications.paginate(page: params[:page], per_page: 20)
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
