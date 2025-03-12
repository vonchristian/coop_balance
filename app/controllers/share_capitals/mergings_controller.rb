module ShareCapitals
  class MergingsController < ApplicationController
    def create
      @current_share_capital = current_cooperative.share_capitals.find(params[:share_capital_id])
      @merging = ShareCapitals::Merging.new(merging_params)
      @merging.merge!
      redirect_to share_capital_url(@current_share_capital), notice: "Share capital accounts merged successfully."
    end

    private

    def merging_params
      params.require(:share_capitals_merging)
            .permit(:cart_id, :current_share_capital_id)
    end
  end
end
