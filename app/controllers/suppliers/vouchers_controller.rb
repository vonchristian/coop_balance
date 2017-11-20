module Suppliers
  class VouchersController < ApplicationController
    def index
      @supplier = Supplier.find(params[:supplier_id])
      @vouchers = @supplier.vouchers.order(date: :desc).paginate(page: params[:page], per_page: 35)
    end
    def new
      @supplier = Supplier.find(params[:supplier_id])
      @voucher = Voucher.new
      @amount = Vouchers::VoucherAmount.new
    end
    def create
      @stock_registry = current_stock_registry
      @supplier = Supplier.find(params[:supplier_id])
      @voucher = Voucher.create(voucher_params)
      if @voucher.save
        @voucher.add_amounts(@supplier)
        redirect_to supplier_vouchers_url(@supplier), notice: "Voucher created successfully."

      else
        render :new
      end
    end

    private
    def voucher_params
      params.require(:voucher).permit(:number, :date, :payee_id, :description, :payee_type, :voucherable_id, :description, :voucherable_type, :user_id, :number, :preparer_id)
    end
  end
end
