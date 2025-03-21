module ShareCapitals
  class MergingLineItemsController < ApplicationController
    def new
      @current_share_capital = current_cooperative.share_capitals.find(params[:share_capital_id])
      @merging_line_item = ShareCapitals::MergingLineItem.new
      @merging = ShareCapitals::Merging.new
      @share_capitals = if params[:search].present?
                          current_cooperative.share_capitals.where.not(id: @current_share_capital.id).text_search(params[:search]).paginate(page: params[:page], per_page: 25)
      else
                          current_cooperative.share_capitals.where.not(id: @current_share_capital.id).text_search(@current_share_capital.subscriber_name).paginate(page: params[:page], per_page: 25)
      end
    end

    def create
      @current_share_capital = current_cooperative.share_capitals.find(params[:share_capital_id])
      @merging_line_item = ShareCapitals::MergingLineItem.new(merging_line_item_params)
      @merging_line_item.save
      redirect_to new_share_capital_merging_line_item_path(@current_share_capital), notice: "Share capital account selected successfully."
    end

    def destroy
      @current_share_capital = current_cooperative.share_capitals.find(params[:current_share_capital_id])
      @share_capital = current_cooperative.share_capitals.find(params[:share_capital_id])
      @share_capital.cart_id = nil
      @share_capital.save
      redirect_to new_share_capital_merging_line_item_url(@current_share_capital), notice: "Removed successfully."
    end

    private

    def merging_line_item_params
      params.require(:share_capitals_merging_line_item)
            .permit(:cart_id, :old_share_capital_id)
    end
  end
end
