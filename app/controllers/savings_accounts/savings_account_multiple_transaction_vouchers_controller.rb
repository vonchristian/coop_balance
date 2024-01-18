module SavingsAccounts
  class SavingsAccountMultipleTransactionVouchersController < ApplicationController
    def show
      @voucher = current_office.vouchers.includes(voucher_amounts: [account: :ledger]).find(params[:id])
    end
  end
end