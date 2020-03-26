module BankingAgentModule 
  class UtilityBillsController < ApplicationController
    layout "banking_agent"

    skip_before_action :authenticate_user!, only: [:index, :show]

    def index 
      if params[:search].present? 
        @utility_bills = UtilityBill.account_number_search(params[:search])
      end 
    end 

    def show 
      @utility_bill = UtilityBill.find(params[:id])
    end 
  end 
end 