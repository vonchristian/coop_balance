module Portfolios
	class LoansController < ApplicationController

		def index
			if params[:to_date].present? && params[:loan_type]
				@loan_type = current_cooperative.loan_products.find(params[:loan_type])
				@to_date = params[:to_date].present? ? Date.parse(params[:to_date]) : Time.now
      	@loans = current_cooperative.loans.not_cancelled.where(loan_product: @loan_type).order(:borrower_full_name)
      else
      	@loans = current_cooperative.loans
      end
      respond_to do |format|
	      format.html
	      format.xlsx
	    end
		end
	end
end