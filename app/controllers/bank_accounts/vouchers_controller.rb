module BankAccounts
  class VouchersController < ApplicationController
    def show
      @bank_account = current_cooperative.bank_accounts.find(params[:bank_account_id])
      @voucher = current_cooperative.vouchers.find(params[:id])
    end
    def destroy
      @bank_account = current_cooperative.bank_accounts.find.find(params[:bank_account_id])
      @voucher = current_cooperative.vouchers.find(params[:id])
      @voucher.destroy
      redirect_to bank_account_url(@bank_account), notice: 'cancelled successfully.'
    end
  end
end
