module SavingsAccounts
  class SavingsAccountMultipleTransactionVouchersController < ApplicationController
    def show 
      @voucher = current_office.vouchers.find(params[:id])
    end 
  end 
end 