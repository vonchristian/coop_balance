module LoansModule
  module Reports
    class LoanReleasesController < ApplicationController
      def index
        @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : DateTime.now.at_beginning_of_month
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : DateTime.now
        @loans = LoansModule::Loan.disbursed(from_date: @from_date, to_date: @to_date)
        respond_to do |format|
          format.html
          format.pdf do
            pdf = LoansModule::Reports::LoanReleasesPdf.new(@loans, @from_date, @to_date, view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Loan Releases Report.pdf"
          end
        end
      end
    end
  end
end
