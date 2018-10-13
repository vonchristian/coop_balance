module SavingsAccounts
  class DepositConfirmationsController < ApplicationController
    def create
      @voucher = current_cooperative.vouchers.find(params[:voucher_id])
      @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
      SavingsAccounts::VoucherProcessing.new(voucher_id: @voucher.id).process!
      redirect_to savings_account_url(@savings_account), notice: "Confirmed successfully."
    end
  end
end
