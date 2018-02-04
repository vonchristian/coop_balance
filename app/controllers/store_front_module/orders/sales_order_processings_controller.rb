module StoreFrontModule
  module Orders
    class SalesOrderProcessingsController < ApplicationController
      def new
        @sales_order = StoreFrontModule::Orders::SalesOrderProcessing.new
        @cart = current_cart
      end
      def create
        @cart = current_cart
        @sales_order = StoreFrontModule::Orders::SalesOrderProcessing.new(order_processing_params)
        if @sales_order.valid?
          @sales_order.process!
          redirect_to store_front_module_index_url, notice: "Order processed successfully."
        else
          render :new
        end
      end

      private
      def order_processing_params
        params.require(:store_front_module_orders_sales_order_processing).permit(:customer_id, :date, :cash_tendered, :order_change, :total_cost, :employee_id, :cart_id)
      end
    end
  end
end
