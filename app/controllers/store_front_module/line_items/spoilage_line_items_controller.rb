module StoreFrontModule
  module LineItems
    class SpoilageLineItemsController < ApplicationController
      def new
        if params[:search].present?
          @products = StoreFrontModule::Product.text_search(params[:search]).all
          @line_items = StoreFrontModule::LineItems::PurchaseLineItem.includes(:unit_of_measurement).text_search(params[:search])
        end
        @cart = current_cart
        @spoilage_line_item = StoreFrontModule::LineItems::SpoilageLineItemProcessing.new
        @spoilage_order = StoreFrontModule::Orders::SpoilageOrderProcessing.new
        @spoilage_line_items = @cart.spoilage_line_items.order(created_at: :desc)
      end

      def create
        @cart = current_cart
        @spoilage_line_item = StoreFrontModule::LineItems::SpoilageLineItemProcessing.new(line_item_params)
        if @spoilage_line_item.process!

          redirect_to new_store_front_module_spoilage_line_item_url, notice: 'Added successfully'
        else
          render :new, status: :unprocessable_entity
        end
      end

      def destroy
        @cart = current_cart
        @line_item = StoreFrontModule::LineItems::SpoilageLineItem.find(params[:id])
        @line_item.destroy
        redirect_to new_store_front_module_spoilage_line_item_url, alert: 'Removed successfully'
      end

      private

      def line_item_params
        params.require(:store_front_module_line_items_spoilage_line_item_processing)
              .permit(:unit_of_measurement_id, :quantity, :cart_id, :product_id, :purchase_line_item_id, :unit_cost, :total_cost)
      end
    end
  end
end
