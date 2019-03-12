module Portfolios
	class ShareCapitalsController < ApplicationController

		def index
			if params[:to_date].present?
				@to_date = params[:to_date].present? ? Date.parse(params[:to_date]) : Time.now
      	@share_capitals = current_office.share_capitals.order(:account_owner_name)
      else
      	@share_capitals = current_office.share_capitals
      end
      respond_to do |format|
	      format.html
	      format.xlsx
	    end
		end
	end
end
