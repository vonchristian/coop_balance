module Portfolios
	class TimeDepositsController < ApplicationController

		def index
			if params[:to_date].present?
				@from_date = MembershipsModule::TimeDeposit.order(:date_deposited).first.date_deposited
				@to_date = params[:to_date].present? ? Date.parse(params[:to_date]) : Time.now
      	@time_deposits = current_cooperative.time_deposits.not_withdrawn.where(date_deposited: @from_date..@to_date).order(:depositor_name)
      else
      	@time_deposits = current_cooperative.time_deposits
      end
      respond_to do |format|
	      format.html
	      format.xlsx
	    end
		end
	end
end