module TreasuryModule
  class CashDisbursementVouchersController < ApplicationController
    def show
      @voucher = Voucher.find(params[:id])
    end
    def destroy
      @voucher = Voucher.find(params[:id])
      @voucher.destroy
      redirect_to treasury_module_disbursements_url, notice: "Cancelled successfully"
    end
  end
end
