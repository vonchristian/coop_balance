require "csv"
module Portfolios
  class AveragedDailyBalanceShareCapitalsController < ApplicationController
    def index
      @to_date = params[:to_date].present? ? Date.parse(params[:to_date]) : Time.zone.now
      @share_capital_product = current_office.share_capital_products.find(params[:saving_product_id])
      @share_capitals        = current_office.share_capitals.where(share_capital_product: @share_capital_product)
      @beginning_date        = @to_date.beginning_of_month
      @ending_date           = @to_date.end_of_month

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
      headers["Content-Disposition"] = 'attachment; filename="Share Capitals Daily Averaged Balance.csv"'

      # Don't buffer when going through proxy servers
      headers["X-Accel-Buffering"] = "no"

      # Set an Enumerator as the body
      self.response_body = csv_body

      response.status = 200
    end

    def csv_body
      Enumerator.new do |yielder|
        yielder << CSV.generate_line([ "#{current_office.name} - Share Capitals Daily Averaged Balance" ])
        yielder << CSV.generate_line([ "Depositor", "Share Capital Product" ] + (@beginning_date..@ending_date).to_a.map { |a| a.strftime("%B %e, %Y") })
        @share_capitals.order(:account_owner_name).each do |share_capital|
          yielder << CSV.generate_line(
            [
              share_capital.account_owner_name,
              share_capital.share_capital_product_name
            ] +
               (@beginning_date..@ending_date).to_a.map { |date| share_capital.balance(to_date: date.end_of_day) }
          )
        end
      end
    end
  end
end
