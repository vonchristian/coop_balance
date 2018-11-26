module LoansModule
  module LoanApplications
    class SavingsAccountDepositProcessingsController < ApplicationController
      def new
        @loan_application = current_cooperative.loan_applications.find(params[:loan_application_id])
        @savings_account = current_cooperative.savings.find(params[:saving_id])
        @deposit         = LoansModule::LoanApplications::SavingsAccountDepositProcessing.new
      end
      def create
        @loan_application = current_cooperative.loan_applications.find(params[:loan_application_id])
        @deposit         = LoansModule::LoanApplications::SavingsAccountDepositProcessing.new(deposit_params)
        if @deposit.valid?
          @deposit.process!
          redirect_to new_loans_module_loan_application_voucher_url(@loan_application), notice: "Savings deposit added successfully"
        else
          render :new
        end
      end

      private
      def deposit_params
        params.require(:loans_module_loan_applications_savings_account_deposit_processing).
        permit(:amount, :loan_application_id, :savings_account_id)
      end
    end
  end
end
