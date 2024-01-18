module AccountingModule
  module Entries
    class PerEmployeeEntriesController < ApplicationController
      def index
        @employee = params[:recorder_id] ? current_cooperative.users.find(params[:recorder_id]) : current_user
        @from_date = params[:from_date] ? DateTime.parse(params[:from_date]).beginning_of_day : DateTime.now.beginning_of_day
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]).end_of_day : DateTime.now.end_of_day
        if params[:entry_type].present?
          @entries = @employee.entries.order(reference_number: :desc).where(entry_type: params[:entry_type].to_sym)
        elsif params[:from_date].present? && params[:to_date].present?
          @from_date = DateTime.parse(params[:from_date])
          @to_date = DateTime.parse(params[:to_date])
          @entries = @employee.entries.order(reference_number: :desc).entered_on(from_date: @from_date, to_date: @to_date)
        elsif params[:search].present?
          @entries = @employee.entries.text_search(params[:search])
        else
          @entries = @employee.entries.order(reference_number: :desc)
        end
        @paginated_entries = @entries.paginate(page: params[:page], per_page: 50)
        respond_to do |format|
          format.html
          format.pdf do
            pdf = AccountingModule::EntriesPdf.new(
              from_date: @from_date,
              to_date: @to_date,
              entries: entries_for_pdf_report,
              employee: @employee,
              cooperative: current_cooperative,
              view_context: view_context
            )
            send_data pdf.render, type: 'application/pdf', disposition: 'inline', file_name: 'Entries report.pdf'
          end
        end
      end

      def entries_for_pdf_report
        @employee = if params[:recorder_id].present?
                      current_cooperative.users.find(params[:recorder_id])
                    else
                      current_user
                    end
        @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : current_cooperative.entries.order(entry_date: :asc).first.entry_date
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Time.zone.today.end_of_year
        @entries = @employee.entries.order(reference_number: :desc)
      end
    end
  end
end
