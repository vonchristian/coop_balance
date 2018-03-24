module StoreFrontModule
  module LineItems
    class SalesLineItemsController < ApplicationController
      def new
        if params[:search].present?
          @products = StoreFrontModule::Product.text_search(params[:search]).all
          @line_items = StoreFrontModule::LineItems::PurchaseLineItem.includes(:unit_of_measurement).text_search(params[:search])
        end
        @cart = current_cart
        @sales_line_item = StoreFrontModule::LineItems::SalesLineItemProcessing.new
        @sales_order = StoreFrontModule::Orders::SalesOrderProcessing.new
        @sales_line_items = @cart.sales_line_items.order(created_at: :desc)
      end
      def create
        @cart = current_cart
        @sales_line_item = StoreFrontModule::LineItems::SalesLineItemProcessing.new(line_item_params)
        if @sales_line_item.valid?
          @sales_line_item.process!
          redirect_to new_store_front_module_sales_line_item_url, notice: "Added to cart."
        else
          render :new
        end
      end
      def destroy
        @line_item = StoreFrontModule::LineItems::SalesLineItem.find_by(id: params[:id])
        @line_item.destroy
        redirect_to new_store_front_module_sales_line_item_url
      end
      private
      def line_item_params
        params.require(:store_front_module_line_items_sales_line_item_processing).
        permit(:unit_of_measurement_id,
               :quantity,
               :unit_cost,
               :total_cost,
               :product_id,
               :barcode,
               :cart_id,
               :purchase_line_item_id)
      end
    end
  end
end
