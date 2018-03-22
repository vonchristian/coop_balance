module StoreFrontModule
  module Orders
    class SalesReturnsController < ApplicationController
      def index
        @sales_return_orders = StoreFrontModule::Orders::SalesReturnOrder.order(date: :desc).all.paginate(page: params[:page], per_page: 35)
      end
      def show
        @sales_return_order = StoreFrontModule::Orders::SalesReturnOrder.find(params[:id])
        @customer = @sales_return_order.customer
      end
    end
  end
end
