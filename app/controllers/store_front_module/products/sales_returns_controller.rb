module StoreFrontModule
  module Products
    class SalesReturnsController < ApplicationController
      def index
        @product = StoreFrontModule::Product.find(params[:product_id])

        @sales_returns = @product.sales_returns.order(date: :desc).all.paginate(page: params[:page], per_page: 35)
      end
    end
  end
end
