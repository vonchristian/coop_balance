module Portfolios
	class ShareCapitalsController < ApplicationController

		def index
			@to_date = params[:to_date].present? ? Date.parse(params[:to_date]) : Time.now
			if params[:share_capital_product_id].present?
				@share_capital_product = current_office.share_capital_products.find(params[:share_capital_product_id])
      	@share_capitals        = current_office.share_capitals.where(share_capital_product: @share_capital_product).order(:account_owner_name)
      else
      	@share_capitals = current_office.share_capitals
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

		def csv_body
			Enumerator.new do |yielder|
				yielder << CSV.generate_line(["#{current_office.name} - Share Capital Portfolio"])
				yielder << CSV.generate_line(["Subscriber", "Balance", "Share Capital Product", "Last Transaction Date"])
				@share_capitals.each do |share_capital|
					yielder << CSV.generate_line([
						share_capital.account_owner_name,
						share_capital.balance(to_date: @to_date),
						share_capital.share_capital_product_name,
						share_capital.last_transaction_date.strftime('%B %e, %Y')
						])
				end
			end
		end
	end
end
