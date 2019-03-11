module LoansModule
  module Reports
    class LoanReleasesController < ApplicationController
      def index
        @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : DateTime.now.at_beginning_of_month
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : DateTime.now
        @loans = current_cooperative.loans.not_cancelled.order(tracking_number: :asc).disbursed.disbursed_on(from_date: @from_date, to_date: @to_date)
        @cooperative = current_cooperative
        respond_to do |format|
          format.html
          format.xlsx
          format.pdf do
            pdf = LoansModule::Reports::LoanReleasesPdf.new(
              loans: @loans,
              from_date: @from_date,
              to_date: @to_date,
              cooperative: @cooperative,
              view_context: view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Loan Releases Report.pdf"
          end
        end
      end
    end
  end
end
