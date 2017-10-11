class VouchersController < ApplicationController 
  def index 
    @vouchers = Voucher.all.paginate(page: params[:page], per_page: 50)
  end 
  def show 
    @voucher = Voucher.find(params[:id])
  end
end 