module StoreFrontModule
  module Orders
    class SpoilageOrderProcessingsController < ApplicationController
      def create
        @cart = current_cart
        @spoilage_order = StoreFrontModule::Orders::SpoilageOrderProcessing.new(spoilage_processing_params)
        if @spoilage_order.valid?
          @spoilage_order.process!
          redirect_to new_store_front_module_spoilage_url, notice: "Spoilage Order processed successfully."
        else
          redirect_to new_store_front_module_spoilage_url, alert: "Error processing spoilage order."
        end
      end

      private
      def spoilage_processing_params
        params.require(:store_front_module_orders_spoilage_order_processing).permit(:date, :employee_id, :cart_id, :title, :content)
      end
    end
  end
end
