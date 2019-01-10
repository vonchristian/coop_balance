module SavingsAccounts
  class VoucherConfirmationsController < ApplicationController
    def create
      @voucher = current_cooperative.vouchers.find(params[:voucher_id])
      @savings_account = current_cooperative.savings.find(params[:savings_account_id])
      ActiveRecord::Base.transaction do
	      Vouchers::EntryProcessing.new(updateable: @savings_account, voucher: @voucher, employee: current_user).process!
	      MinimumBalanceChecker.new(account: @savings_account, product: @savings_account.saving_product).check_balance!
	    end
      redirect_to savings_account_url(@savings_account), notice: "Confirmed successfully."
    end
  end
end
