module StoreFrontModule
  module Products
    class PurchaseReturnsController < ApplicationController
      def index
        @product = StoreFrontModule::Product.find(params[:product_id])
        @purchase_returns = @product.
        purchase_returns.
        processed.
        order(date: :desc).
        paginate(page: params[:page], per_page: 35)
      end
    end
  end
end
