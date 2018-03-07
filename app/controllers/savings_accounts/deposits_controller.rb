module SavingsAccounts
  class DepositsController < ApplicationController
    def new
      @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
      @deposit = Memberships::SavingsAccounts::DepositProcessing.new
      authorize [:savings_accounts, :deposit]
    end
    def create
      @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
      @deposit = Memberships::SavingsAccounts::DepositProcessing.new(deposit_params)
      authorize [:savings_accounts, :deposit]

      if @deposit.valid?
        @deposit.save
        redirect_to savings_account_url(@savings_account), notice: "Savings deposit saved successfully"
      else
        render :new
      end
    end

    private
    def deposit_params
      params.require(:memberships_savings_accounts_deposit_processing).permit(:amount, :or_number, :date, :saving_id, :employee_id, :payment_type)
    end
  end
end
