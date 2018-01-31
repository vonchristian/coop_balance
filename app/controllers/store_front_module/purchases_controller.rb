module StoreFrontModule
  class PurchasesController < ApplicationController
    def new
      @stock = StockDelivery.new
      @registry = StockRegistry.new
    end
    def create
      @stock = StockDelivery.new(stock_params)
      if @stock.valid?
        @stock.save
        redirect_to new_store_module_stock_path, notice: 'added successfully'
      else
        render :new
      end
    end
    def destroy
      @stock = StoreFrontModule::ProductStock.find(params[:id])
      @stock.destroy
      redirect_to new_supplier_purchase_url(@stock.supplier), notice: "Removed successfully."
    end
  end
end
