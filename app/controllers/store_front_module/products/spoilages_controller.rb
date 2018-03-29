module StoreFrontModule
  module Products
    class SpoilagesController < ApplicationController
      def index
        @product = Product.find(params[:product_id])
        @spoilages = @product.spoilages.processed.order(date: :desc).paginate(page: params[:page], per_page: 25)
      end
    end
  end
end
