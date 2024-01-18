module AccountingModule
  module Reports
    class StatementOfOperationsController < ApplicationController
      def index
        first_entry = current_office.entries.order(entry_date: :asc).first
        @from_date  = first_entry ? DateTime.parse(first_entry.entry_date.strftime('%B %e, %Y')) : Time.zone.now
        @to_date    = params[:to_date] ? DateTime.parse(params[:to_date]).end_of_day : Date.current

        respond_to do |format|
          format.html
          format.pdf do
            pdf = AccountingModule::Reports::StatementOfOperationPdf.new(
              from_date: @from_date,
              to_date: @to_date,
              office: current_office,
              view_context: view_context,
              cooperative: current_cooperative
            )
            send_data pdf.render, type: 'application/pdf', disposition: 'inline', file_name: 'Statement Of Operation.pdf'
            nil
          end
        end
      end
    end
  end
end