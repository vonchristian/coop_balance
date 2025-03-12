module ShareCapitals
  class WithdrawalVoucherConfirmationsController < ApplicationController
    def create
      @voucher = current_office.vouchers.find(params[:voucher_id])
      @share_capital = current_office.share_capitals.find(params[:share_capital_id])
      ActiveRecord::Base.transaction do
        Vouchers::EntryProcessing.new(updateable: @share_capital, voucher: @voucher, employee: current_user).process!
        BalanceStatusChecker.new(account: @share_capital, product: @share_capital.share_capital_product).set_balance_status
        set_share_capital_as_withdrawn!
      end
      redirect_to share_capital_url(@share_capital), notice: "Transaction confirmed successfully."
    end

    private

    def set_share_capital_as_withdrawn!
      @share_capital.update(withdrawn_at: @voucher.date)
    end
  end
end
