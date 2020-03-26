class BankingAgentsController < ApplicationController
  layout "banking_agent"

  skip_before_action :authenticate_user!, only: [:show]

  def show 
    @banking_agent = current_banking_agent
  end 
end 