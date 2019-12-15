module ShareCapitals
  class VoucherConfirmationsController < ApplicationController
    def create
      @voucher       = current_office.vouchers.find(params[:voucher_id])
      @share_capital = current_office.share_capitals.find(params[:share_capital_id])
      ApplicationRecord.transaction do
	      Vouchers::EntryProcessing.new(updateable: @share_capital, voucher: @voucher, employee: current_user).process!
        BalanceStatusChecker.new(account: @share_capital, product: @share_capital.share_capital_product).set_balance_status
	    end

      redirect_to share_capital_accounting_index_url(@share_capital), notice: "Transaction confirmed successfully."
    end
  end
end
