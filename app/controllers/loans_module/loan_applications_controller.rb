module LoansModule
  class LoanApplicationsController < ApplicationController
    def new
      @loan = LoansModule::Loan.new
    end
    def create
      @loan = LoansModule::Loan.create(loan_params)
      @loan.employee = current_user
      if @loan.valid?
        @loan.save
        @loan.create_charges
        @loan.set_capital_build_up
        @loan.set_filing_fee
        @loan.set_loan_protection_fee
        redirect_to loans_module_loan_application_url(@loan), notice: "Loan application saved successfully."
        @loan.set_interest_on_loan_charge
        @loan.create_amortization_schedule
        @loan.set_borrower_type
        @loan.set_borrower_full_name
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
      @loan = LoansModule::Loan.find(params[:id])
      @loan.update(loan_params)
      if @loan.save
        @loan.create_charges
        @loan.set_capital_build_up
        @loan.set_filing_fee
        @loan.set_loan_protection_fee
        redirect_to loans_module_loan_application_url(@loan), notice: "Loan updated successfully"
        @loan.set_interest_on_loan_charge
        @loan.create_amortization_schedule
        
      else 
        render :edit 
      end 
    end 
    def destroy
      @loan = LoansModule::Loan.find(params[:id])
      @loan.destroy
      redirect_to loans_url, notice: "Loan application cancelled successfully"
    end

    private
    def loan_params
      params.require(:loans_module_loan).permit(:borrower_id, :borrower_type, :term, :loan_product_id, :loan_amount, :member_id, :application_date, :duration, :loan_term_duration, :mode_of_payment, :application_date)
    end
  end
end
