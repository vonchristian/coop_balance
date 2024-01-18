module Vouchers
  class CancellationsController < ApplicationController
    def create
      @voucher = current_office.vouchers.find(params[:voucher_id])
      Vouchers::Cancellation.new(voucher: @voucher).cancel!
      redirect_to '/', notice: 'Voucher cancelled succesfully.'
    end
  end
end
