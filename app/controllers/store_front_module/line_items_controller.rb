module StoreFrontModule
  class LineItemsController < ApplicationController
    def create
      if params[:search].present?
        @stocks = StoreFrontModule::ProductStock.text_search(params[:search]).all.to_a.sort_by(&:date).reverse
      else
        @stocks = StoreFrontModule::ProductStock.all
      end
      @cart = current_cart
      @checkout = StoreFrontModule::CheckoutForm.new
      @line_item = StoreFrontModule::LineItemProcessing.new(line_item_params)
      if @line_item.valid?
        @line_item.process!
        redirect_to store_front_module_index_url, notice: "Added to cart."
      else
        redirect_to store_front_module_index_url
      end
    end
    def destroy
      @line_item = StoreFrontModule::LineItem.find(params[:id])
      @line_item.destroy
      redirect_to store_index_url
    end

    private
    def line_item_params
      params.require(:store_front_module_line_item).permit(:line_itemable_id, :line_itemable_type, :quantity,  :unit_of_measurement_id, :cart_id, :search)
    end
  end
end
