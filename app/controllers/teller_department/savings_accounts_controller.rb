module TellerDepartment
  class SavingsAccountsController < ApplicationController
    def index
    	if params[:search].present?
    		@savings_accounts = Saving.text_search(params[:search])
    	else 
        @savings_accounts = Saving.includes([:member, :saving_product]).all
      end
    end
    def show 
    	@savings_account = Saving.includes(entries: :recorder).find(params[:id])
    end
  end
end
