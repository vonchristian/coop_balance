module Portfolios
	class SavingsController < ApplicationController

		def index
			@to_date            = params[:to_date].present? ? Date.parse(params[:to_date]) : Time.zone.now
			if params[:saving_product_id].present?
			  @saving_product   = current_office.saving_products.find(params[:saving_product_id])
				@savings_accounts = current_office.savings.where(saving_product: @saving_product).order(:account_owner_name)
      else
      	@savings_accounts = current_office.savings
      end
      respond_to do |format|
	      format.html
				format.xlsx
				format.csv { render_csv }
	    end
		end

		private 

		def render_csv
			# Tell Rack to stream the content
			headers.delete("Content-Length")

			# Don't cache anything from this generated endpoint
			headers["Cache-Control"] = "no-cache"

			# Tell the browser this is a CSV file
			headers["Content-Type"] = "text/csv"

			# Make the file download with a specific filename
			headers["Content-Disposition"] = "attachment; filename=\"Savings Portfolio.csv\""

			# Don't buffer when going through proxy servers
			headers["X-Accel-Buffering"] = "no"

			# Set an Enumerator as the body
			self.response_body = csv_body

			response.status = 200
		end

		private

		def csv_body
			Enumerator.new do |yielder|
				yielder << CSV.generate_line(["#{current_office.name} - Savings Portfolio"])
				yielder << CSV.generate_line(["Depositor", "Balance", "Saving Product", "Last Transaction Date"])
				@savings_accounts.each do |savings_account|
					yielder << CSV.generate_line([
						savings_account.account_owner_name,
						savings_account.balance(to_date: @to_date),
						savings_account.saving_product_name,
						savings_account.last_transaction_date.strftime('%B %e, %Y')
						])
				end
			end 
		end 
	end
end
