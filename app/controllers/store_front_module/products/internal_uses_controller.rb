module StoreFrontModule
  module Products
    class InternalUsesController < ApplicationController
      def index
        @product = Product.find(params[:product_id])
        @internal_uses = @product.internal_uses.processed.order(date: :desc).paginate(page: params[:page], per_page: 25)
      end
    end
  end
end
