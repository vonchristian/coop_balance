module StoreFrontModule
  class LineItemsController < ApplicationController
    def create
      @cart = current_cart
      @checkout = StoreFrontModule::CheckoutForm.new
      @line_item = StoreFrontModule::LineItems::SalesOrderLineItemProcessing.new(line_item_params)
      if @line_item.valid?
        @line_item.process!
        redirect_to store_front_module_index_url, notice: 'Added to cart.'
      else
        redirect_to store_front_module_index_url
      end
    end

    def destroy
      @line_item = StoreFrontModule::LineItem.find(params[:id])
      @line_item.destroy
      redirect_to new_supplier_purchase_url(@line_item.commercial_document)
    end

    private

    def line_item_params
      params.require(:store_front_module_line_items_sales_order_line_item_processing).permit(:commercial_document_id, :commercial_document_type, :unit_of_measurement_id, :quantity, :cart_id, :product_id, :unit_cost, :total_cost, :cart_id, :barcode)
    end
  end
end
