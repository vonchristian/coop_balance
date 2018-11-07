class ShareCapitalsBelowMinimumBalancesController < ApplicationController
  def index
    @share_capitals = current_cooperative.share_capitals.below_minimum_balance.order(updated_at: :desc).paginate(page: params[:page], per_page: 25)
  end
end
