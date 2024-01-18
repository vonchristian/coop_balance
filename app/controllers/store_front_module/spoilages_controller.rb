module StoreFrontModule
  class SpoilagesController < ApplicationController
    def index; end

    def new
      if params[:search].present?
        @products = StoreFrontModule::Product.text_search(params[:search]).all
        @line_items = StoreFrontModule::LineItems::PurchaseOrderLineItem.text_search(params[:search])
      end
      @cart = current_cart
      @spoilage_line_item = StoreFrontModule::LineItems::SpoilageOrderLineItemProcessing.new
      @spoilage_order = StoreFrontModule::Orders::SpoilageOrderProcessing.new
      @spoilage_order_line_items = @cart.spoilage_order_line_items.order(created_at: :desc)
    end

    def create
      @cart = current_cart
      @line_item = StoreFrontModule::LineItems::SpoilageOrderLineItemProcessing.new(spoilage_params)
      if @line_item.valid?
        @line_item.process!
        redirect_to new_store_front_module_spoilage_url, notice: 'Added to cart.'
      else
        redirect_to new_store_front_module_spoilage_url, alert: 'Exceeded available quantity'
      end
    end

    def destroy
      @cart = current_cart
      @spoilage_line_item = StoreFrontModule::LineItems::SpoilageOrderLineItem.find(params[:id])
      @spoilage.destroy
      redirect_to new_store_front_module_spoilage_url, notice: 'Removed successfully'
    end

    private

    def spoilage_params
      params.require(:store_front_module_line_items_spoilage_order_line_item_processing).permit(:unit_of_measurement_id, :quantity, :cart_id, :product_id, :unit_cost, :total_cost, :cart_id, :barcode, :referenced_line_item_id)
    end
  end
end
