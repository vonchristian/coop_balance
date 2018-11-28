module SavingsAccounts
  class AccountClosingVouchersController < ApplicationController
    def show
      @savings_account = current_cooperative.savings.find(params[:savings_account_id])
      @voucher = current_cooperative.vouchers.find(params[:id])
    end

    def destroy
      @savings_account = current_cooperative.savings.find(params[:savings_account_id])
      @voucher = current_cooperative.vouchers.find(params[:id])
      @voucher.destroy
      redirect_to savings_account_url(@savings_account), notice: 'cancelled successfully.'
    end
  end
end
