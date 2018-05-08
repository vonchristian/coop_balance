module Metrics
  class SavingsAccountsController < ApplicationController
    def index
      @query = SavingsAccounts::Query.new
      @limiting_num = params[:limiting_num].to_i || 10
      @top_savings = MembershipsModule::Saving.top_savers(limiting_num: @limiting_num)
      if params[:saving_product_id].present?
        @top_savings = CoopServicesModule::SavingProduct.find(params[:saving_product_id]).
                       subscribers.
                       top_savers(limiting_num: @limiting_num)
      end
    end
    def create
      @query = SavingsAccounts::Query.new(query_params)
      @results = SavingsAccounts::Query.results
      redirect_to metrics_savings_accounts_url
    end
  end
end
