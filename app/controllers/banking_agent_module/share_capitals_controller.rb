module BankingAgentModule 
  class ShareCapitalsController < ApplicationController
    layout "banking_agent"

    skip_before_action :authenticate_user!, only: [:index, :show]

    def index 
      if params[:search].present?
        @share_capitals = current_banking_agent.share_capitals.account_number_search(params[:search])
      end 
    end 

    def show 
      @share_capital = current_banking_agent.share_capitals.find(params[:id])
    end 
  end 
end 