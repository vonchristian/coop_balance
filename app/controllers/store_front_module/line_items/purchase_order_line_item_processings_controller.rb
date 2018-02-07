module StoreFrontModule
  module LineItems
    class PurchaseOrderLineItemProcessingsController < ApplicationController
      def create
        @cart = current_cart
        @purchase_order_line_item = StoreFrontModule::LineItems::PurchaseOrderLineItemProcessing.new(line_item_params)
        if @purchase_order_line_item.valid?
          @purchase_order_line_item.process!
          redirect_to new_store_front_module_purchase_order_url, notice: "Added to cart."
        else
          redirect_to new_store_front_module_purchase_order_url, alert: "Error adding to cart"
        end
      end
      def destroy
        @cart = current_cart
        @line_item = StoreFrontModule::LineItems::PurchaseOrderLineItem.find(params[:id])
        @line_item.destroy
        redirect_to new_store_front_module_purchase_order_url
      end

      private
      def line_item_params
        params.require(:store_front_module_line_items_purchase_order_line_item_processing).permit(:unit_of_measurement_id, :quantity,:unit_cost, :total_cost, :product_id,  :referenced_line_item_id, :cart_id)
      end
    end
  end
end
