module StoreModule
  module Products
    class SalesController < ApplicationController
      def index
        @product = StoreModule::Product.find(params[:product_id])
        @orders = @product.orders.all.paginate(page: params[:page], per_page: 50)
      end
    end
  end
end
