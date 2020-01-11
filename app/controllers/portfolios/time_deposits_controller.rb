module Portfolios
	class TimeDepositsController < ApplicationController

		def index
			@to_date   = params[:to_date].present? ? Date.parse(params[:to_date]) : Time.now

			if params[:time_deposit_product_id].present?
				@time_deposit_product = current_office.time_deposit_products.find(params[:time_deposit_product_id])	
      	@time_deposits        = current_office.time_deposits.where(time_deposit_product: @time_deposit_product)
      else
      	@time_deposits = current_office.time_deposits
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
			headers["Content-Disposition"] = "attachment; filename=\"Time Deposits Portfolio.csv\""

			# Don't buffer when going through proxy servers
			headers["X-Accel-Buffering"] = "no"

			# Set an Enumerator as the body
			self.response_body = csv_body

			response.status = 200
		end

		private

		def csv_body
			Enumerator.new do |yielder|
				yielder << CSV.generate_line(["#{current_office.name} - Time Deposits Portfolio"])
				yielder << CSV.generate_line(["Depositor", "Balance", "Time Deposit Product", "Maturity Date"])
				@time_deposits.each do |time_deposit|
					yielder << CSV.generate_line([
						time_deposit.depositor_name,
						time_deposit.balance(to_date: @to_date),
						time_deposit.time_deposit_product_name,
						time_deposit.term_maturity_date.strftime('%B %e, %Y')
						])
				end
			end 
		end 
	end
end
