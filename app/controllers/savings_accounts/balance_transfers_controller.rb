module SavingsAccounts
  class BalanceTransfersController < ApplicationController
    def new
      @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
      @balance_transfer = Memberships::SavingsAccounts::BalanceTransferProcessing.new
    end
    def create
      @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
      @balance_transfer = Memberships::SavingsAccounts::BalanceTransferProcessing.new(balance_transfer_params)
      if @balance_transfer.valid?
        @balance_transfer.process!
        redirect_to savings_account_url(@savings_account), notice: "Balance transfer saved successfully."
      else
        render :new
      end
    end

    private
    def balance_transfer_params
      params.require(:memberships_savings_accounts_balance_transfer_processing).
      permit(:origin_id, :destination_id, :reference_number, :amount, :date, :employee_id)
    end
  end
end

