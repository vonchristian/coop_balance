module LoansModule
  module Reports
    class LoanCollectionsController < ApplicationController
      def index
        @from_date    = params[:from_date] ? DateTime.parse(params[:from_date]) : DateTime.now.at_beginning_of_month
        @to_date      = params[:to_date] ? DateTime.parse(params[:to_date]).end_of_day : DateTime.now.end_of_day
        @loan_product = current_cooperative.loan_products.find(params[:loan_type]) if params[:loan_type].present?
        @loans = if @loan_product.present?
                   @loan_product.loans
                 else
                   current_office.loans
                 end

        respond_to do |format|
          format.csv { render_csv }
          format.html
          format.xlsx
          format.pdf do
            pdf = LoansModule::Reports::LoanCollectionsPdf.new(
              collections: @collections,
              from_date: @from_date,
              to_date: @to_date,
              cooperative: current_cooperative,
              loan_product: @loan_product,
              view_context: view_context
            )
            send_data pdf.render, type: 'application/pdf', disposition: 'inline', file_name: 'Loan Collections Report.pdf'
          end
        end
      end

      private

      def render_csv
        # Tell Rack to stream the content
        headers.delete('Content-Length')

        # Don't cache anything from this generated endpoint
        headers['Cache-Control'] = 'no-cache'

        # Tell the browser this is a CSV file
        headers['Content-Type'] = 'text/csv'

        # Make the file download with a specific filename
        headers['Content-Disposition'] = 'attachment; filename="Loans Portfolio.csv"'

        # Don't buffer when going through proxy servers
        headers['X-Accel-Buffering'] = 'no'

        # Set an Enumerator as the body
        self.response_body = csv_body

        response.status = 200
      end

      def csv_body
        Enumerator.new do |yielder|
          yielder << CSV.generate_line(["#{current_office.name} Loan Collections"])
          yielder << CSV.generate_line(['Borrower', 'Loan Product', "Principal Balance #{@from_date.strftime('%b. %e, %Y')}", 'Interest Collections', 'Penalty Collections', "Principal Balance #{@to_date.strftime('%b. %e, %Y')}"])
          @loans.order(:borrower_name).each do |loan|
            yielder << CSV.generate_line([
                                           loan.borrower_full_name,
                                           loan.loan_product_name,
                                           loan.principal_balance(to_date: @from_date),
                                           loan.interest_revenue_account.balance(from_date: @from_date, to_date: @to_date),
                                           loan.penalty_revenue_account.balance(from_date: @from_date, to_date: @to_date),
                                           loan.principal_balance(to_date: @to_date)

                                         ])
          end
        end
      end
    end
  end
end
