module StoreFrontModule
  class SalesOrderLineItemsController < ApplicationController
    def create
      @cart = current_cart
      @line_item = StoreFrontModule::LineItems::SalesOrderLineItemProcessing.new(line_item_params)
      if @line_item.valid?
        @line_item.process!
        redirect_to store_front_module_index_url, notice: "Added to cart."
      else
        redirect_to store_front_module_index_url, alert: "Exceeded available quantity"
      end
    end
    def destroy
      @cart = current_cart
      @product = StoreFrontModule::Product.find_by(id: params[:id])
      if @product.present?
        @cart.line_items.where(product: @product).destroy_all
      end
      @line_item = StoreFrontModule::LineItems::SalesOrderLineItem.find_by(id: params[:id])
      if @line_item.present?
        @line_item.destroy
      end
      redirect_to store_front_module_index_url
    end

    private
    def line_item_params
      params.require(:store_front_module_line_items_sales_order_line_item_processing).permit(:unit_of_measurement_id, :quantity, :cart_id, :product_id, :unit_cost, :total_cost, :cart_id, :barcode, :purchase_order_line_item_id)
    end
  end
end
