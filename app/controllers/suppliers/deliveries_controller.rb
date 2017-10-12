module Suppliers 
  class DeliveriesController < ApplicationController
    def index 
      @supplier = Supplier.find(params[:supplier_id])
      @stock_registries = @supplier.stock_registries

    end 
    def new 
      @stock_registry = current_stock_registry
      @supplier = Supplier.find(params[:supplier_id])
      @stock = StoreModule::ProductStock.new
      @product = StoreModule::Product.new
      @voucher = Voucher.new
    end 
    def create
      @stock_registry = current_stock_registry
      @supplier = Supplier.find(params[:supplier_id])
      @stock = @stock_registry.stocks.create(stock_params)
      if @stock.save 
        redirect_to new_supplier_delivery_url(@supplier), notice: "Stock added successfully"
      else 
        redirect_to new_supplier_delivery_url(@supplier), alert: "Error"
      end 
    end 

    private 
    def stock_params
      params.require(:store_module_product_stock).permit(:product_id, :date, :quantity, :unit_cost, :total_cost, :barcode, :supplier_id)
    end
  end 
end 