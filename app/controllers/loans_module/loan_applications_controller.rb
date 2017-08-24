module LoansModule
  class LoanApplicationsController < ApplicationController
    def new
      @loan = LoansModule::Loan.new
    end
    def create
      @loan = LoansModule::Loan.create(loan_params)
      if @loan.valid?
        @loan.save
        @loan.create_charges
        redirect_to loans_module_loan_application_url(@loan), notice: "Loan application saved successfully."
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
        redirect_to loans_module_loan_application_url(@loan), notice: "Loan updated successfully"
      else 
        render :edit 
      end 
    end 

    private
    def loan_params
      params.require(:loans_module_loan).permit(:term, :loan_product_id, :loan_amount, :member_id, :application_date, :duration, :loan_term_duration, :mode_of_payment)
    end
  end
end
