module ShareCapitals
  class VouchersController < ApplicationController
    def show
      @voucher = Voucher.find(params[:id])
      @share_capital = MembershipsModule::ShareCapital.find(params[:share_capital_id])
    end
  end
end
