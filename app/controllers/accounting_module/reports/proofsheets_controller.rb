module AccountingModule
  module Reports
    class ProofsheetsController < ApplicationController
      def index
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Time.zone.now
        @accounts = current_cooperative.accounts.active
        respond_to do |format|
          format.html
          format.xlsx
          format.pdf do
            pdf = AccountingModule::Reports::ProofsheetPdf.new(
              to_date:      @to_date,
              accounts:     @accounts,
              employee:     current_user,
              view_context: view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Consolidated Proofsheet Report.pdf"
          end
        end
      end
    end
  end
end
