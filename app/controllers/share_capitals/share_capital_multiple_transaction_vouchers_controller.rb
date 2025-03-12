module ShareCapitals
  class ShareCapitals::ShareCapitalMultipleTransactionVouchersController < ApplicationController
    def show
      @voucher = current_office.vouchers.find(params[:id])
    end
  end
end
