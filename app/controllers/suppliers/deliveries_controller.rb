module Suppliers
  class DeliveriesController < ApplicationController
    def index
      @supplier = Supplier.find(params[:supplier_id])
    end
    def new
      @supplier = Supplier.find(params[:supplier_id])
      @stock = @supplier.supplied_stocks.build
      @stock_registry = current_stock_registry
      @product = StoreFrontModule::Product.text_search(params[:search]).last
      @voucher = @supplier.vouchers.text_search(params[:voucher_search]).last
      @delivery_processing = Suppliers::DeliveryProcessing.new
    end
    def create
      @supplier = Supplier.find(params[:supplier_id])
      @stock = @supplier.supplied_stocks.build(stock_params)
      @stock.registry = current_stock_registry
      if   @stock.valid?
        @stock.save
        redirect_to new_supplier_delivery_url(@supplier), notice: "Stock added successfully"
      else
        render :new
      end
    end

    private
    def stock_params
      params.require(:store_front_module_product_stock).permit(:product_id, :date, :quantity, :purchase_cost, :total_purchase_cost, :barcode, :supplier_id, :selling_price)
    end
  end
end
