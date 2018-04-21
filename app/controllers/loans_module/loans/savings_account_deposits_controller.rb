module LoansModule
  module Loans
    class SavingsAccountDepositsController < ApplicationController
      def new
        @loan = LoansModule::Loan.find(params[:loan_id])
        @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
        @deposit = LoansModule::Loans::SavingsAccountDeposit.new
      end
      def create
        @loan = LoansModule::Loan.find(params[:loan_id])
        @deposit = LoansModule::Loans::SavingsAccountDeposit.new(deposit_params)
        if @deposit.valid?
          @deposit.add_to_loan_charges!
          redirect_to loans_module_loan_application_url(@loan), notice: "Savings Account Deposit saved successfully"
        else
          render :new
        end
      end

      private
      def deposit_params
        params.require(:loans_module_loans_savings_account_deposit).
        permit(:amount, :savings_account_id, :loan_id)
      end
    end
  end
end
