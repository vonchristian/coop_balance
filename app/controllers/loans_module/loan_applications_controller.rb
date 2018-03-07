module LoansModule
  class LoanApplicationsController < ApplicationController
    def new
      @loan = LoansModule::LoanApplicationForm.new
    end

    def create
      @loan = LoansModule::LoanApplicationForm.new(loan_params)
      if @loan.valid?
        @loan.save
        # @loan.create_loan_product_charges
        # @loan.create_documentary_stamp_tax
        # @loan.set_loan_protection_fund
        redirect_to loans_module_loan_application_url(@loan.find_loan), notice: "Loan application saved successfully."
        # @loan.create_amortization_schedule
        # @loan.set_borrower_type
        # @loan.set_borrower_full_name
        # @loan.set_organization
        # @loan.set_barangay
      else
        render :new
      end
    end
    def show
      @loan = LoansModule::Loan.find(params[:id])
    end
    def edit
      @loan = LoansModule::Loan.find(params[:id])
    end
    def update
       @loan = LoansModule::Loan.create(loan_params)
      @loan.employee = current_user
      if @loan.valid?
        @loan.save
        @loan.create_loan_product_charges
        @loan.create_documentary_stamp_tax
        @loan.set_loan_protection_fund
        redirect_to loans_module_loan_application_url(@loan), notice: "Loan application saved successfully."
        @loan.create_amortization_schedule
        @loan.set_borrower_type
        @loan.set_borrower_full_name
        @loan.set_organization
      else
        render :new
      end
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
