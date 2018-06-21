class SavingsAccountsDashboardsController < ApplicationController
  def index
    @savings_accounts = MembershipsModule::Saving.all
  end
end
