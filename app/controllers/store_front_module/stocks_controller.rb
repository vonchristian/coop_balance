module StoreFrontModule
  class StocksController < ApplicationController
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
  end
end
