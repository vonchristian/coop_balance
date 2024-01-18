module LoansModule
  module LoanProducts
    class LoanAgingGroupsController < ApplicationController
      def index; end

      def show
        @loan_product     = current_office.loan_products.find(params[:id])
        @loan_aging_group = current_office.loan_aging_groups.find(params[:loan_aging_group_id])
        @to_date          = params[:to_date].present? ? Date.parse(params[:to_date]) : Time.zone.now
        @loans            = @loan_aging_group.loans.where(loan_product: @loan_product)

        respond_to do |format|
          format.csv { render_csv }
        end
      end

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

      private

      def csv_body
        Enumerator.new do |yielder|
          yielder << CSV.generate_line(["#{current_office.name} - #{@loan_product.name} Loans Portfolio"])
          yielder << CSV.generate_line(['Borrower', 'Loan Product', 'Loan Purpose', 'Principal Balance', 'Interests Payments', 'Penalty Payments', 'Disbursement Date', 'Maturity Date'])
          @loans.each do |loan|
            yielder << CSV.generate_line([
                                           loan.borrower_full_name,
                                           loan.loan_product_name,
                                           loan.purpose,
                                           loan.principal_balance(to_date: @to_date),
                                           loan.loan_interests_balance,
                                           loan.loan_penalties_balance,
                                           loan.disbursement_date.try(:strftime, '%B %e, %Y'),
                                           loan.maturity_date.try(:strftime, '%B %e, %Y')
                                         ])
          end
        end
      end
    end
  end
end