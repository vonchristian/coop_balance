module BankingAgentModule
  class SavingsController < ApplicationController
    layout "banking_agent"
    
    skip_before_action :authenticate_user!, only: [:index, :show]

    def index 
      if params[:search].present?
        @savings = current_banking_agent.savings.account_number_search(params[:search])
      end 
    end 

    def show 
      @saving = current_banking_agent.savings.find(params[:id])
    end 
  end 
end 