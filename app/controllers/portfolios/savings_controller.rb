module Portfolios
	class SavingsController < ApplicationController

		def index
			if params[:to_date].present?
				@to_date = params[:to_date].present? ? Date.parse(params[:to_date]) : Time.now
      	@savings_accounts = MembershipsModule::Saving.all.order(:account_owner_name)
      else
      	@savings_accounts = MembershipsModule::Saving.all
      end
      respond_to do |format|
	      format.html
	      format.xlsx
	    end
		end
	end
end
