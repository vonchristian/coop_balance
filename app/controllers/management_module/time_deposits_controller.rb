module ManagementDepartment
  class TimeDepositsController < ApplicationController
    def index
    	if params[:search].present?
    		@time_deposits = TimeDeposit.text_search(params[:search])
    	else 
        @time_deposits = TimeDeposit.includes([:member, :time_deposit_product]).all
      end
    end
    def show 
    	@time_deposit = TimeDeposit.includes(entries: :recorder).find(params[:id])
    end
  end
end
