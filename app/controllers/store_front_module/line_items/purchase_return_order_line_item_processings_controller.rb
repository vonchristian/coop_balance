module StoreFrontModule
  module LineItems
    class PurchaseReturnOrderLineItemProcessingsController < ApplicationController
      def new
        if params[:search].present?
          @products = StoreFrontModule::Product.text_search(params[:search]).all
        end
        @cart = current_cart
        @purchase_return_order_line_item = StoreFrontModule::LineItems::PurchaseReturnOrderLineItemProcessing.new
        @purchase_return_order = StoreFrontModule::Orders::PurchaseReturnOrderProcessing.new
        @purchase_return_order_line_items = @cart.purchase_return_order_line_items.order(created_at: :desc)

      end
      def create
        @cart = current_cart
        @purchase_return_order_line_item = StoreFrontModule::LineItems::PurchaseReturnOrderLineItemProcessing.new(line_item_params)
        if @purchase_return_order_line_item.valid?
          @purchase_return_order_line_item.process!
          redirect_to new_store_front_module_purchase_return_order_line_item_processing_url, notice: "Added successfully"
        else
          render :new
        end
      end
      def destroy
        @cart = current_cart
        @line_item = StoreFrontModule::LineItems::PurchaseReturnOrderLineItem.find(params[:id])
        @line_item.destroy
        redirect_to new_store_front_module_purchase_return_order_line_item_processings_url
      end

      private
      def line_item_params
        params.require(:store_front_module_line_items_purchase_return_order_line_item_processing).permit(:unit_of_measurement_id, :quantity, :cart_id, :product_id, :referenced_line_item_id, :unit_cost, :total_cost)
      end
    end
  end
end
