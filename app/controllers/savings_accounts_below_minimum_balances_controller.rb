class SavingsAccountsBelowMinimumBalancesController < ApplicationController
  def index
    @savings_accounts = current_cooperative.savings.below_minimum_balance.order(updated_at: :desc).paginate(page: params[:page], per_page: 25)
  end
end
