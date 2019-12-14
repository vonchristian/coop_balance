module ShareCapitals
  class WithdrawalVouchersController < ApplicationController
    def show
      @share_capital = current_office.share_capitals.find(params[:share_capital_id])
      @voucher = current_office.vouchers.find(params[:id])
    end
  end
end
