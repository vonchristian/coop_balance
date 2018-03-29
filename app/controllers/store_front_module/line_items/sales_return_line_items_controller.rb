module StoreFrontModule
  module LineItems
    class SalesReturnLineItemsController < ApplicationController
      def new
        if params[:search].present?
          @products = StoreFrontModule::Product.text_search(params[:search]).all
          @line_items = StoreFrontModule::LineItems::PurchaseLineItem.includes(:unit_of_measurement).text_search(params[:search])
        end
        @cart = current_cart
        @sales_return_line_item = StoreFrontModule::LineItems::SalesReturnLineItemProcessing.new
        @sales_return_order = StoreFrontModule::Orders::SalesReturnOrderProcessing.new
        @sales_return_line_items = @cart.sales_return_line_items.order(created_at: :desc)
      end

      def create
        @cart = current_cart
        @sales_return_line_item = StoreFrontModule::LineItems::SalesReturnLineItemProcessing.new(line_item_params)
        if @sales_return_line_item.valid?
          @sales_return_line_item.process!
          redirect_to new_store_front_module_sales_return_line_item_url, notice: "Added to cart."
        else
          redirect_to new_store_front_module_sales_return_line_item_url, alert: "Error. Exceeded sold quantity"
        end
      end
      def destroy
        @cart = current_cart
        @line_item = StoreFrontModule::LineItems::SalesReturnLineItem.find(params[:id])
        @line_item.destroy
        redirect_to new_store_front_module_sales_return_line_item_url
      end

      private
      def line_item_params
        params.require(:store_front_module_line_items_sales_return_line_item_processing).
        permit(:customer_id, :unit_of_measurement_id, :quantity, :cart_id, :product_id, :purchase_line_item_id)
      end
    end
  end
end
