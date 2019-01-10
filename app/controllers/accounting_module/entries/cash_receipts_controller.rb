module AccountingModule
  module Entries
    class CashReceiptsController < ApplicationController
      def index
        if params[:from_date].present? && params[:to_date].present?
          @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : current_cooperative.entries.order(entry_date: :asc).first.entry_date
          @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today.end_of_year
          @entries = current_cooperative.cash_accounts.debit_entries.order(reference_number: :desc, entry_date: :desc).entered_on(from_date: @from_date, to_date: @to_date).paginate(:page => params[:page], :per_page => 50)
        elsif params[:search].present?
          @entries = current_cooperative.cash_accounts.debit_entries.order(reference_number: :desc, entry_date: :desc).text_search(params[:search]).paginate(:page => params[:page], :per_page => 50)
        elsif params[:recorder_id].present?
          @recorder = current_cooperative.users.find(params[:recorder_id])
          @entries = @recorder.cash_accounts.debit_entries.order(reference_number: :desc, entry_date: :desc).paginate(:page => params[:page], :per_page => 50)
        elsif params[:account_id].present?
          @entries = current_cooperative.cash_accounts.find(params[:account_id]).debit_entries.order(reference_number: :desc, entry_date: :desc).paginate(:page => params[:page], :per_page => 50)
        # elsif params[:office_id].present?
        #   @office  = current_cooperative.offices.find(params[:office_id])
        #   @entries = current_cooperative.offices.find(params[:office_id]).entries.paginate(:page => params[:page], :per_page => 50)
        else
          @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : current_cooperative.entries.order(entry_date: :asc).first.entry_date
          @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today.end_of_year
          @entries = current_cooperative.cash_accounts.debit_entries.order(reference_number: :desc, entry_date: :desc).paginate(page: params[:page], per_page:  50)
        end
      end
    end
  end
end
