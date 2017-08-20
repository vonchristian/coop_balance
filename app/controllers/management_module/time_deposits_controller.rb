module ManagementModule
  class TimeDepositsController < ApplicationController
    def index
    	if params[:search].present?
    		@time_deposits = MembershipsModule::TimeDeposit.text_search(params[:search])
    	else 
        @time_deposits = MembershipsModule::TimeDeposit.includes([:member, :time_deposit_product]).all
      end
    end
    def show 
    	@time_deposit = MembershipsModule::TimeDeposit.includes(entries: :recorder).find(params[:id])
    end
  end
end
