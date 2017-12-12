module LoansModule
  module Reports
    class LoanReleasesController < ApplicationController
      def index
        @date = Time.zone.now
        @loans = LoansModule::Loan.disbursed_on(date: @date)
        respond_to do |format|
          format.html
          format.pdf do
            pdf = LoansModule::Reports::LoanReleasesPdf.new(@loans, @date, view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Loan Releases Report.pdf"
          end
        end
      end
    end
  end
end
