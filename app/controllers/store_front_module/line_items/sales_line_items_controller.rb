module StoreFrontModule
  module LineItems
    class SalesLineItemsController < ApplicationController
      def new
        if params[:search].present?
          @products = current_cooperative.products.text_search(params[:search]).all
          @line_items = current_store_front.purchase_line_items.includes(:unit_of_measurement).processed.text_search(params[:search])
        end
        @cart = current_cart
        @sales_line_item = StoreFrontModule::LineItems::SalesLineItemProcessing.new
        @sales_order = StoreFrontModule::Orders::SalesOrderProcessing.new
        @sales_line_items = @cart.sales_line_items.includes(:unit_of_measurement, :product).order(created_at: :desc)
      end

      def create
        @cart = current_cart
        @sales_line_item = StoreFrontModule::LineItems::SalesLineItemProcessing.new(line_item_params)
        if @sales_line_item.process!
          @sales_line_item.process!
          redirect_to new_store_front_module_sales_line_item_url, notice: "Added to cart."
        else
          render :new, status: :unprocessable_entity
        end
      end

      def destroy
        @line_item = StoreFrontModule::LineItems::SalesLineItem.find_by(id: params[:id])
        @line_item.destroy
        redirect_to new_store_front_module_sales_line_item_url
      end

      private

      def line_item_params
        params.require(:store_front_module_line_items_sales_line_item_processing)
              .permit(:unit_of_measurement_id,
                      :quantity,
                      :unit_cost,
                      :total_cost,
                      :product_id,
                      :barcode,
                      :cart_id,
                      :employee_id,
                      :store_front_id,
                      :purchase_line_item_id)
      end
    end
  end
end
