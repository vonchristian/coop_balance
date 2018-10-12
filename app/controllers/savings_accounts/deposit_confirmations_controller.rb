module SavingsAccounts
  class DepositConfirmationsController < ApplicationController
    def show
      @voucher = current_cooperative.vouchers.find(params[:id])
      @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
    end
    def create
      @voucher = current_cooperative.vouchers.find(params[:voucher_id])
      @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
      SavingsAccounts::DepositProcessing.new(voucher_id: @voucher.id).process!
      redirect_to savings_account_url(@savings_account), notice: "Deposit confirmed successfully."
    end
  end
end
