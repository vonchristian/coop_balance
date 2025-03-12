module LoansModule
  module Reports
    class LoanReleasesController < ApplicationController
      def index
        @from_date    = params[:from_date] ? DateTime.parse(params[:from_date]).beginning_of_day : DateTime.now.at_beginning_of_month
        @to_date      = params[:to_date] ? DateTime.parse(params[:to_date]).end_of_day : DateTime.now.end_of_month
        @loan_product = params[:loan_product_id] ? current_office.loan_products.find(params[:loan_product_id]) : current_office.loan_products.first
        @loans = @loan_product.loans.not_cancelled.disbursed_on(from_date: @from_date, to_date: @to_date)
        @cooperative  = current_cooperative
        respond_to do |format|
          format.html
          format.xlsx
          format.csv { render_csv }
          format.pdf do
            pdf = LoansModule::Reports::LoanReleasesPdf.new(
              loans: @loans,
              from_date: @from_date,
              to_date: @to_date,
              cooperative: @cooperative,
              view_context: view_context
            )
            send_data pdf.render, type: "application/pdf", disposition: "inline", file_name: "Loan Releases Report.pdf"
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
        headers["Content-Disposition"] = 'attachment; filename="Loans Portfolio.csv"'

        # Don't buffer when going through proxy servers
        headers["X-Accel-Buffering"] = "no"

        # Set an Enumerator as the body
        self.response_body = csv_body

        response.status = 200
      end

      def csv_body
        Enumerator.new do |yielder|
          yielder << CSV.generate_line([ "#{current_office.name} Loan Disbursements" ])
          yielder << CSV.generate_line([ "Borrower", "Loan Product", "Loan Purpose", "Voucher #", "Loan Amount", "Principal Balance", "Interests", "Disbursement Date", "Maturity Date" ])
          @loans.order(:borrower_name).each do |loan|
            yielder << CSV.generate_line([
                                           loan.borrower_full_name,
                                           loan.loan_product_name,
                                           loan.purpose,
                                           loan.disbursement_voucher.try(:reference_number),
                                           loan.loan_amount,
                                           loan.principal_balance(to_date: @to_date),
                                           loan.interest_revenue_account.credits_balance(from_date: @to_date.beginning_of_year, to_date: @to_date),
                                           loan.disbursement_date.try(:strftime, "%B %e, %Y"),
                                           loan.maturity_date.try(:strftime, "%B %e, %Y")
                                         ])
          end
        end
      end
    end
  end
end
