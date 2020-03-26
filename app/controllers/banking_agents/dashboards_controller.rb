module BankingAgents 
  class DashboardsController < ApplicationController
    layout "banking_agent"
    skip_before_action :authenticate_user!, only: [:index]
    def index 
    end 
  end 
end 