module Suppliers
  class AmountsController < ApplicationController
    def create
      @supplier = Supplier.find(params[:supplier_id])
      @amount = Suppliers::VoucherAmountProcessing.new(amount_params)
      if @amount.valid?
      @amount.process!
      redirect_to new_supplier_voucher_url(@supplier), notice: "Added successfully."
      else
        redirect_to new_supplier_voucher_url(@supplier), alert: "Error."
      end
    end
    def destroy
      @supplier = Supplier.find(params[:supplier_id])
      @voucher_amount = Vouchers::VoucherAmount.find(params[:id])
      @voucher_amount.destroy
      redirect_to new_supplier_voucher_url(@supplier), notice:"Removed successfully."
  end
    private
    def amount_params
      params.require(:suppliers_voucher_amount_processing).permit(:amount, :account_id, :description, :amount_type, :commercial_document_id)
    end
  end
end
