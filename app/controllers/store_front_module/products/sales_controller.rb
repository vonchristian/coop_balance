module StoreFrontModule
  module Products
    class SalesController < ApplicationController
      def index
        @product = StoreFrontModule::Product.find(params[:product_id])
        @orders = @product.
        sales.
        processed.
        all.
        paginate(page: params[:page], per_page: 50)
      end
    end
  end
end
