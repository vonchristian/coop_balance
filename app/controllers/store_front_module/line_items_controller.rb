module StoreFrontModule
  class LineItemsController < ApplicationController
    def create
      @cart = current_cart
      @line_item = @cart.line_items.create(line_item_params)
      respond_to do |format|
        if @line_item.save
          # @line_item.retail!
          @cart.add_line_item(@line_item)
            format.html { redirect_to store_index_url, notice: "Added to cart." }
            format.js   { @current_item = @line_item }
        else
          format.html { redirect_to store_index_url }
        end
      end
    end

    def destroy
      @line_item = StoreFrontModule::LineItem.find(params[:id])
      @line_item.destroy
      redirect_to store_index_url
    end

    private
    def line_item_params
      params.require(:store_front_module_line_item).permit(:pricing_type, :user_id, :line_itemable_id, :line_itemable_type, :quantity, :unit_cost, :total_cost)
    end
  end
end
