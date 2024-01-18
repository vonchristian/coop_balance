module StoreFrontModule
  module Products
    class SalesReturnsController < ApplicationController
      def index
        @product = StoreFrontModule::Product.find(params[:product_id])
        @sales_returns = @product
                         .sales_returns
                         .processed
                         .order(date: :desc)
                         .paginate(page: params[:page], per_page: 35)
      end
    end
  end
end
