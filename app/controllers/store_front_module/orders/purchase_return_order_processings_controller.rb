module StoreFrontModule
  module Orders
    class PurchaseReturnOrderProcessingsController < ApplicationController
      def index
        @purchase_return_orders = StoreFrontModule::Orders::PurchaseReturnOrder.all
      end
      def new
        @order = StoreFrontModule::Orders::PurchaseReturnOrderProcessing.new
         @cart = current_cart
      end
      def create
        @purchase_return_order = StoreFrontModule::Orders::PurchaseReturnOrderProcessing.new(purchase_order_params)
        if @purchase_return_order.valid?
          @purchase_return_order.process!
          redirect_to store_front_module_purchase_return_orders_url, notice: "Purchase Return processed successfully."
        else
          redirect_to new_store_front_module_purchase_return_order_line_item_processing_url, alert: "Error"
        end
      end

      private
      def purchase_order_params
        params.require(:store_front_module_orders_purchase_return_order_processing).permit(:supplier_id, :cart_id, :employee_id, :date)
      end
    end
  end
end
