module StoreFrontModule
  module Products
    class StockTransfersController < ApplicationController
      def index
        @product = Product.find(params[:product_id])
        @stock_transfers = @product.stock_transfers.processed.order(date: :desc).paginate(page: params[:page], per_page: 25)
      end
    end
  end
end
