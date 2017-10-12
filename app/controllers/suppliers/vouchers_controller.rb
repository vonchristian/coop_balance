module Suppliers 
  class VouchersController < ApplicationController
    def new 
      @supplier = Supplier.find(params[:supplier_id])
      @voucher = Voucher.new 
      @entry = AccountingModule::Entry.new 
      @entry.debit_amounts.build
    end
    def create 
      @stock_registry = current_stock_registry
      @supplier = Supplier.find(params[:supplier_id])
      @voucher = Voucher.create(voucher_params)
      if @voucher.save 
        @supplier.create_entry_for(@voucher)
        StockRegistry.transfer_stocks_from(@stock_registry, @supplier)
        redirect_to supplier_url(@supplier), notice: "Voucher created successfully."

      else 
        render :new 
      end 
    end 

    private 
    def voucher_params
      params.require(:voucher).permit(:number, :date, :payee_id, :payee_type, :voucherable_id, :description, :voucherable_type, :user_id)
    end 
  end 
end 