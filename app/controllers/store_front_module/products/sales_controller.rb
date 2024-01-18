module StoreFrontModule
  module Products
    class SalesController < ApplicationController
      def index
        @product = current_cooperative.products.find(params[:product_id])
        @sales_orders = @product
                        .sales_orders
                        .processed
                        .order(date: :desc)
                        .paginate(page: params[:page], per_page: 25)
      end
    end
  end
end
