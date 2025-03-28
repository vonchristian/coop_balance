module StoreFrontModule
  module Orders
    class CreditSalesController < ApplicationController
      def create
        if Member.find_by(id: params[:customer_id]).present?
          @customer = Member.find_by(id: params[:customer_id])
        elsif User.find_by(id: params[:customer_id]).present?
          @customer = User.find_by(id: params[:customer_id])
        end
        @cart = current_cart
        @sales_order = StoreFrontModule::Orders::CreditSalesOrderProcessing.new(order_processing_params)
        if @sales_order.valid?
          @sales_order.process!
          redirect_to "/", notice: "Order processed successfully."
        else
          redirect_to new_store_front_module_customer_credit_sales_line_item_url(customer_id: params[:customer_id]), alert: "Error"
        end
      end

      private

      def order_processing_params
        params.require(:store_front_module_orders_credit_sales_order_processing)
              .permit(:description, :customer_id, :date, :total_cost, :employee_id, :cart_id, :reference_number, :description)
      end
    end
  end
end
