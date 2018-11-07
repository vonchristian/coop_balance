module AccountingModule
  module Reports
    class ProofsheetsController < ApplicationController
      def index
        @from_date = params[:from_date] ? Chronic.parse(params[:from_date]) : Time.zone.now.at_beginning_of_month
        @to_date = params[:to_date] ? Chronic.parse(params[:to_date]) : Time.zone.now
        @accounts = current_cooperative.accounts.updated_at(from_date: @from_date, to_date: @to_date).paginate(page: params[:page], per_page: 50)
        respond_to do |format|
          format.html
          format.xlsx
          format.pdf do
            pdf = AccountingModule::Reports::ProofsheetPdf.new(@from_date, @to_date, @accounts, view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Consolidated Proofsheet Report.pdf"
          end
        end
      end
    end
  end
end
