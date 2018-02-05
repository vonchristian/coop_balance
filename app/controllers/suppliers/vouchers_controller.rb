module Suppliers
  class VouchersController < ApplicationController
    def index
      @supplier = Supplier.find(params[:supplier_id])
      @vouchers = @supplier.vouchers.order(date: :desc).paginate(page: params[:page], per_page: 35)
    end
    def new
      @supplier = Supplier.find(params[:supplier_id])
      @voucher = Suppliers::VoucherProcessing.new
      @amount = Suppliers::VoucherAmountProcessing.new
    end
    def create
      @supplier = Supplier.find(params[:supplier_id])
      @amount = Suppliers::VoucherAmountProcessing.new
      @voucher = Suppliers::VoucherProcessing.new(voucher_params)
      if @voucher.valid?
        @voucher.process!
        redirect_to supplier_vouchers_url(@supplier), notice: "Voucher created successfully."

      else
        render :new
      end
    end

    private
    def voucher_params
      params.require(:suppliers_voucher_processing).permit(:number, :date, :payee_id, :description, :user_id, :number, :preparer_id)
    end
  end
end
