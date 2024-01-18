module ShareCapitals
  class ConfirmationsController < ApplicationController
    def create
      @voucher = current_cooperative.vouchers.find(params[:voucher_id])
      @share_capital = current_cooperative.share_capitals.find(params[:share_capital_id])
      ActiveRecord::Base.transaction do
        Vouchers::EntryProcessing.new(updateable: @share_capital, voucher: @voucher, employee: current_user).process!
        BalanceStatusChecker.new(account: @share_capital, product: @share_capital.share_capital_product).set_balance_status
      end
      redirect_to share_capital_url(@share_capital), notice: 'Capital build up transaction saved successfully.'
    end
  end
end
