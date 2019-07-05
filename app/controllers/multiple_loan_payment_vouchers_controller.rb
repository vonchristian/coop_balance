class MultipleLoanPaymentVouchersController < ApplicationController
  def show
    @voucher = current_office.vouchers.find(params[:id])
  end
end
