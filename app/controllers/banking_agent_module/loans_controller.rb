module BankingAgentModule
  class LoansController < ApplicationController
    layout "banking_agent"
    
    skip_before_action :authenticate_user!, only: [:index, :show]

    def index 
      if params[:search].present?
        @loans = current_banking_agent.loans.account_number_search(params[:search])
      end 
    end 

    def show 
      @loan = current_banking_agent.loans.find(params[:id])
    end 
  end 
end 