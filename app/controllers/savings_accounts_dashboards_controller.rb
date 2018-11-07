class SavingsAccountsDashboardsController < ApplicationController
  def index
    @savings_accounts = current_cooperative.savings
  end
end
