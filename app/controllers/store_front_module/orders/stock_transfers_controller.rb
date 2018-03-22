module StoreFrontModule
  module Orders
    class StockTransfersController < ApplicationController
      def index
        @stock_transfers = StoreFrontModule::Orders::StockTransferOrder.all
      end
    end
  end
end
