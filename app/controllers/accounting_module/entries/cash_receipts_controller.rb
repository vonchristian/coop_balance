module AccountingModule
  module Entries
    class CashReceiptsController < ApplicationController
      def index
        if params[:from_date].present? && params[:to_date].present?
          @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : current_cooperative.entries.order(entry_date: :asc).first.entry_date
          @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today.end_of_year
          @ordered_entries = current_cooperative.cash_accounts.debit_entries.order(reference_number: :desc).entered_on(from_date: @from_date, to_date: @to_date)
          @entries = @ordered_entries.paginate(:page => params[:page], :per_page => 50)
        elsif params[:search].present?
          @entries = current_cooperative.cash_accounts.debit_entries.order(reference_number: :desc).text_search(params[:search])
          @entries = @ordered_entries.paginate(:page => params[:page], :per_page => 50)
        elsif params[:recorder_id].present?
          @recorder = current_cooperative.users.find(params[:recorder_id])
          @ordered_entries = @recorder.cash_accounts.debit_entries.order(reference_number: :desc)
          @entries = @ordered_entries.paginate(:page => params[:page], :per_page => 50)
        elsif params[:account_id].present?
          @ordered_entries = current_cooperative.cash_accounts.find(params[:account_id])
          @entries = @ordered_entries.debit_entries.order(reference_number: :desc).paginate(:page => params[:page], :per_page => 50)
        # elsif params[:office_id].present?
        #   @office  = current_cooperative.offices.find(params[:office_id])
        #   @entries = current_cooperative.offices.find(params[:office_id]).entries.paginate(:page => params[:page], :per_page => 50)
        else
          @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : current_cooperative.entries.order(entry_date: :asc).first.entry_date
          @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today.end_of_year
          @ordered_entries = current_cooperative.cash_accounts.debit_entries.order(reference_number: :desc)
          @entries = @ordered_entries.paginate(page: params[:page], per_page:  50)
        end
        respond_to do |format|
          format.html
          format.pdf do
            pdf = AccountingModule::EntriesPdf.new(
              from_date:    @from_date,
              to_date:      @to_date,
              entries:     entries_for_pdf,
              employee:     current_user,
              cooperative:  current_cooperative,
              view_context: view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Entries report.pdf"
          end
        end
      end

      private
      def entries_for_pdf
        if params[:from_date].present? && params[:to_date].present?
          @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : current_cooperative.entries.order(entry_date: :asc).first.entry_date
          @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today.end_of_year
          @entries = current_cooperative.cash_accounts.debit_entries.where(cancelled: false).order(reference_number: :asc).entered_on(from_date: @from_date, to_date: @to_date)
        elsif params[:search].present?
          @entries = current_cooperative.cash_accounts.debit_entries.where(cancelled: false).order(reference_number: :asc).text_search(params[:search])
        elsif params[:recorder_id].present?
          @recorder = current_cooperative.users.find(params[:recorder_id])
          @entries = @recorder.cash_accounts.debit_entries.where(cancelled: false).order(reference_number: :asc)
        # elsif params[:office_id].present?
        #   @office  = current_cooperative.offices.find(params[:office_id])
        #   @entries = current_cooperative.offices.find(params[:office_id]).entries.paginate(:page => params[:page], :per_page => 50)
        else
          @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : current_cooperative.entries.order(entry_date: :asc).first.entry_date
          @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today.end_of_year
          @entries = current_cooperative.cash_accounts.debit_entries.where(cancelled: false).order(reference_number: :asc)
        end
      end
    end
  end
end
