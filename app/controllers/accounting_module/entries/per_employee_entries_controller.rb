module AccountingModule
  module Entries
    class PerEmployeeEntriesController < ApplicationController
      def index
        @employee = params[:recorder_id] ? current_cooperative.users.find(params[:recorder_id]) : current_user
        @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : current_cooperative.entries.order(entry_date: :asc).first.entry_date
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today.end_of_year
        @entries = @employee.entries.paginate(page: params[:page], per_page: 25)
        respond_to do |format|
          format.html
          format.pdf do
            pdf = AccountingModule::EntriesPdf.new(
              from_date:    @from_date,
              to_date:      @to_date,
              entries:      entries_for_pdf_report,
              employee:     @employee,
              cooperative:  current_cooperative,
              view_context: view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Entries report.pdf"
          end
        end
      end
      def entries_for_pdf_report
        if params[:recorder_id].present?
          @employee = current_cooperative.users.find(params[:recorder_id])
        else
          @employee = current_user
        end
        @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : current_cooperative.entries.order(entry_date: :asc).first.entry_date
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today.end_of_year
        @entries = @employee.entries
      end
    end
  end
end
