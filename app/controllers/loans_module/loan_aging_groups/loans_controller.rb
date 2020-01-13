module LoansModule
  module LoanAgingGroups 
    class LoansController < ApplicationController
      def index 
        @to_date = params[:to_date].present? ? Date.parse(params[:to_date]) : Time.zone.now

        @loan_aging_group = current_office.loan_aging_groups.find(params[:loan_aging_group_id])
        
        @pagy, @loans = pagy(@loan_aging_group.current_loans)
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
        headers["Content-Disposition"] = "attachment; filename=\"Loans Portfolio.csv\""
  
        # Don't buffer when going through proxy servers
        headers["X-Accel-Buffering"] = "no"
  
        # Set an Enumerator as the body
        self.response_body = csv_body
  
        response.status = 200
      end
  
      private
  
      def csv_body
        Enumerator.new do |yielder|
          yielder << CSV.generate_line(["#{current_office.name} - #{@loan_aging_group.title } Loans Portfolio"])
          yielder << CSV.generate_line(["Borrower", "Loan Product", "Loan Purpose", "Principal Balance", 'Interests', 'Penalties',  "Disbursement Date","Maturity Date",  "Number of Days Past Due"])
          @loan_aging_group.current_loans.each do |loan|
            yielder << CSV.generate_line([
              loan.borrower_full_name,
              loan.loan_product_name,
              loan.purpose,
              loan.principal_balance(to_date: @to_date),
              loan.loan_interests_balance,
              loan.loan_penalties_balance,
              loan.disbursement_date.try(:strftime, ("%B %e, %Y")),
              loan.maturity_date.try(:strftime,('%B %e, %Y')),
              loan.number_of_days_past_due
              ])
          end
        end 
      end 
    end
  end
end