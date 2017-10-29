module Suppliers
  class AmountsController < ApplicationController
    def create
      @supplier = Supplier.find(params[:supplier_id])
      @amount = Vouchers::VoucherAmount.create(amount_params)
      @amount.commercial_document = @supplier
      @amount.save
      redirect_to new_supplier_voucher_url(@supplier), notice: "Added successfully."
    end
    def destroy
      @supplier = Supplier.find(params[:supplier_id])
      @voucher_amount = Vouchers::VoucherAmount.find(params[:id])
      @voucher_amount.destroy
      redirect_to new_supplier_voucher_url(@supplier), notice:"Removed successfully."
  end
    private
    def amount_params
      params.require(:vouchers_voucher_amount).permit(:amount, :account_id)
    end
  end
end
