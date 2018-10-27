module TreasuryModule
  class CashReceiptVouchersController < ApplicationController
    def show
      @voucher = Voucher.find(params[:id])
    end
    def destroy
      @voucher = Voucher.find(params[:id])
      @voucher.destroy
      redirect_to treasury_module_cash_receipts_url, notice: "Cancelled successfully"
    end
  end
end
