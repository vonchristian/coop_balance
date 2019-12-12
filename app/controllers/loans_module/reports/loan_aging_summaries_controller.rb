module LoansModule
  module Reports
    class LoanAgingSummariesController < ApplicationController
      def index
        @loans             = current_office.loans
        @loan_aging_groups = current_office.loan_aging_groups.order(start_num: :asc)

        respond_to do |format|
          format.html
          format.csv { render_csv }
        end
      end

      def render_csv
        # Tell Rack to stream the content
        headers.delete("Content-Length")

        # Don't cache anything from this generated endpoint
        headers["Cache-Control"] = "no-cache"

        # Tell the browser this is a CSV file
        headers["Content-Type"] = "text/csv"

        # Make the file download with a specific filename
        headers["Content-Disposition"] = "attachment; filename=\"Stock Inventory.csv\""

        # Don't buffer when going through proxy servers
        headers["X-Accel-Buffering"] = "no"

        # Set an Enumerator as the body
        self.response_body = csv_body

        response.status = 200
      end

      private

      def csv_body
        Enumerator.new do |yielder|
          yielder << CSV.generate_line(["Loan Aging Summary"])
          yielder << CSV.generate_line(["Borrower", "Loan Product", "Date Release", "Maturity Date", "Loan Amount", "Loan Balance"] + @loan_aging_groups.map{|a| a.title} + ['Term', 'Days Past Due', 'Mode of Payment', 'Share Capital', 'Savings Deposit', 'Time Deposit'])

          @loan.each do |loan|
            yielder << CSV.generate_line([
              loan.borrower_name,
              loan.loan_product_name,
              loan.disbursement_date.try(:strftime, ('%B %e, %Y')),
              loan.maturity_date.try(:strftime, ('%B %e, %Y')),
              loan.loan_amount,
              loan.balance] +
              @loan_groups.map{ |loan_group|
                loan.balance_for_loan_group(loan_group)} +
                [loan.term,
                  loan.number_of_days_past_due,
                  loan.mode_of_payment,
                  loan.borrower.share_capitals.try(:total_balances),
                  loan.borrower.savings.try(:total_balances),
                  loan.borrower.time_deposits.try(:total_balances)])
          end
        end
      end
    end
  end
end
