module Portfolios
	class LoansController < ApplicationController

		def index
			if params[:to_date].present? && params[:loan_type]
				@loan_type = current_cooperative.loan_products.find(params[:loan_type])
				@to_date = params[:to_date].present? ? Date.parse(params[:to_date]) : Time.now
      	@loans = current_office.loans.not_cancelled.where(loan_product: @loan_type).order(:tracking_number)
      else
      	@loans = current_office.loans
      end
      respond_to do |format|
	      format.html
	      format.xlsx
	    end
		end
	end
end
