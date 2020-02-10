module AccountingModule
  module Reports
    class TrialBalancesController < ApplicationController
      def index
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.current
        @pagy, @categories = pagy(current_office.level_one_account_categories.updated_at(from_date: @to_date, to_date: @to_date).order(:code))
        respond_to do |format|
          format.html
          format.csv { render_csv }
          format.pdf do
            pdf = AccountingModule::Reports::TrialBalancesPdf.new(
              account_categories:     current_office.account_categories.updated_at(from_date: @to_date,to_date: @to_date),
              to_date:      @to_date,
              cooperative:  @cooperative,
              view_context: view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Trial Balance.pdf"
          end
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
        headers["Content-Disposition"] = "attachment; filename=\"Entries.csv\""
  
        # Don't buffer when going through proxy servers
        headers["X-Accel-Buffering"] = "no"
  
        # Set an Enumerator as the body
        self.response_body = csv_body
  
        response.status = 200
      end
  
      private
  
      def csv_body
        Enumerator.new do |yielder|
          yielder << CSV.generate_line(["Trial Balance"])
          yielder << CSV.generate_line(["DATE", "#{@to_date.strftime('%B %e, %Y')}"])
          yielder << CSV.generate_line(['ACCOUNT', 'BEGINNING BALANCE', 'DEBITS', 'CREDITS', 'ENDING BALANCE'])
          current_office.level_one_account_categories.updated_at(from_date: @to_date, to_date: @to_date).distinct.order(code: :asc).each do |category|
            yielder << CSV.generate_line([
              category.title,
              category.balance(to_date: @to_date.yesterday.end_of_day),
              category.debits_balance(from_date: @to_date, to_date: @to_date),
              category.credits_balance(from_date: @to_date, to_date: @to_date),
              category.balance(to_date: @to_date)
            ])
          end
          yielder << CSV.generate_line([""])
          yielder << CSV.generate_line([
            "TOTAL",
            current_office.level_one_account_categories.updated_at(from_date: @to_date, to_date: @to_date).distinct.balance(to_date: @to_date.yesterday.end_of_day),
            current_office.level_one_account_categories.updated_at(from_date: @to_date, to_date: @to_date).distinct.debits_balance(from_date: @to_date, to_date: @to_date),
            current_office.level_one_account_categories.updated_at(from_date: @to_date, to_date: @to_date).distinct.credits_balance(from_date: @to_date, to_date: @to_date),
            current_office.level_one_account_categories.updated_at(from_date: @to_date, to_date: @to_date).distinct.balance(to_date: @to_date)
          ])
        end 
      end
    end
  end
end
