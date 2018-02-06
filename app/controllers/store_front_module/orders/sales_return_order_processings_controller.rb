module StoreFrontModule
  module Orders
    class SalesReturnOrderProcessingsController < ApplicationController
      def create
        @cart = current_cart
        @sales_order = StoreFrontModule::Orders::SalesReturnOrderProcessing.new(order_processing_params)
        if @sales_order.valid?
          @sales_order.process!
          redirect_to store_front_module_index_url, notice: "Order processed successfully."
        else
          render :new
        end
      end

      private
      def order_processing_params
        params.require(:store_front_module_orders_sales_return_order_processing).permit(:customer_id, :date, :employee_id, :cart_id)
      end
    end
  end
end
