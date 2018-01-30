module StoreFrontModule
  class StockDeliveriesController < ApplicationController
    def new
      @registry = current_stock_registry
      @stock = StockDelivery.new
    end
  end
end
