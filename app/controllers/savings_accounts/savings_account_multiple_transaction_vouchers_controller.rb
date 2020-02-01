module SavingsAccounts
  class SavingsAccountMultipleTransactionVouchersController < ApplicationController
    def show 
      @voucher = current_office.vouchers.includes(:voucher_amounts =>[:account => :level_one_account_category]).find(params[:id])
    end 
  end 
end 