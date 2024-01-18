module AccountingModule
  module Entries
    class PerOfficeEntriesController < ApplicationController
      def index
        @office = params[:office_id] ? current_cooperative.offices.find(params[:office_id]) : current_user.office
        @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : current_cooperative.entries.order(entry_date: :asc).first.entry_date
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Time.zone.today.end_of_year
        @entries = @office.entries.paginate(page: params[:page], per_page: 25)
        respond_to do |format|
          format.html
          format.pdf do
            pdf = AccountingModule::EntriesPdf.new(
              from_date: @from_date,
              to_date: @to_date,
              entries: entries_for_pdf_report,
              office: @office,
              employee: current_user,
              cooperative: current_cooperative,
              view_context: view_context
            )
            send_data pdf.render, type: 'application/pdf', disposition: 'inline', file_name: 'Entries report.pdf'
          end
        end
      end

      def entries_for_pdf_report
        @office = params[:office_id] ? current_cooperative.offices.find(params[:office_id]) : current_user.office
        @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : current_cooperative.entries.order(entry_date: :asc).first.entry_date
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Time.zone.today.end_of_year
        @entries = @office.entries
      end
    end
  end
end
