module Suppliers
  class DeliveriesController < ApplicationController
    def index
      @supplier = Supplier.find(params[:supplier_id])
    end
    def new
      @supplier = Supplier.find(params[:supplier_id])
      @stock = @supplier.supplied_stocks.build
      @stock_registry = current_stock_registry
    end
    def create
      @supplier = Supplier.find(params[:supplier_id])
      @stock = @supplier.supplied_stocks.build(stock_params)
      @stock.registry = current_stock_registry
      if   @stock.save!
        redirect_to new_supplier_delivery_url(@supplier), notice: "Stock added successfully"
      else
        render :new
      end
    end

    private
    def stock_params
      params.require(:store_module_product_stock).permit(:product_id, :date, :quantity, :unit_cost, :total_cost, :barcode, :supplier_id, :retail_price, :wholesale_price)
    end
  end
end
