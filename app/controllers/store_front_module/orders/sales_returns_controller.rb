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
      def create
        @cart = current_cart
        @sales_order = StoreFrontModule::Orders::SalesReturnOrderProcessing.new(order_processing_params)
        if @sales_order.valid?
          @sales_order.process!
          redirect_to store_front_module_sales_returns_url, notice: "Sales return Order processed successfully."
        else
          render :new
        end
      end

      private
      def order_processing_params
        params.require(:store_front_module_orders_sales_return_order_processing).permit(:customer_id, :date, :employee_id, :cart_id, :note)
      end
    end
  end
end
