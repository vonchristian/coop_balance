module TreasuryModule
  class CashDisbursementVouchersController < ApplicationController
    def show
      @voucher = current_cooperative.vouchers.find(params[:id])
    end

    def destroy
      @voucher = current_cooperative.vouchers.find(params[:id])
      @voucher.destroy
      redirect_to treasury_module_disbursements_url, notice: "Cancelled successfully"
    end
  end
end
