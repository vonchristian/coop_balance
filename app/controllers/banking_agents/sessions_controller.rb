module BankingAgents 
  class SessionsController < Devise::SessionsController
    layout "banking_agent_signin"

  skip_before_action :authenticate_user!, only: [:new]
    
    
  
  end 
end 