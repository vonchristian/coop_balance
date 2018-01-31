module Suppliers
  class PurchasesController < ApplicationController
    def index
      @supplier = Supplier.find(params[:supplier_id])
    end
    def new
      @supplier = Supplier.find(params[:supplier_id])
      @stock = Suppliers::StockPurchaseProcessing.new
      @stock_registry = current_stock_registry
      @product = StoreFrontModule::Product.text_search(params[:search]).last
      @voucher = @supplier.vouchers.text_search(params[:voucher_search]).last
      @delivery_processing = Suppliers::PurchaseProcessing.new
    end
    def create
      @supplier = Supplier.find(params[:supplier_id])
      @stock = Suppliers::StockPurchaseProcessing.new(stock_params)
      if @stock.valid?
        @stock.process!
        redirect_to new_supplier_purchase_url(@supplier), notice: "Stock added successfully"
      else
        render :new
      end
    end

    private
    def stock_params
      params.require(:suppliers_stock_purchase_processing).permit(:product_id, :date, :quantity, :purchase_cost, :total_purchase_cost, :barcode, :supplier_id, :selling_price, :unit_of_measurement_id, :registry_id)
    end
  end
end
