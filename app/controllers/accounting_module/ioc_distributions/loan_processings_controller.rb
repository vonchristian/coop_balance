module AccountingModule
  module IocDistributions
    class LoanProcessingsController < ApplicationController
      def new 
        @loan        = current_office.loans.find(params[:loan_id])
        @ioc_payment = AccountingModule::IocDistributions::IocToLoan.new 
      end 

      def create
        @loan        = current_office.loans.find(params[:accounting_module_ioc_distributions_ioc_to_loan][:loan_id])
        @ioc_payment = AccountingModule::IocDistributions::IocToLoan.new(ioc_to_loan_params)
        if @ioc_payment.valid?
          @ioc_payment.process! 
          redirect_to new_accounting_module_ioc_distributions_loan_url, notice: "added successfully."
        else 
          render :new, status: :unprocessable_entity
        end 
      end 

      private 
      def ioc_to_loan_params
        params.require(:accounting_module_ioc_distributions_ioc_to_loan).
        permit(:cart_id, :loan_id, :employee_id, :principal_amount, :interest_amount, :penalty_amount)
      end 
    end 
  end 
end 