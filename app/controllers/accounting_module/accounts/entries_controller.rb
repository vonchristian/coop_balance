module AccountingModule
  module Accounts
    class EntriesController < ApplicationController
      def index
        @account = current_cooperative.accounts.find(params[:account_id])
        @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : Date.today
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today
        if params[:from_date] && params[:to_date]
          @pagy, @entries = pagy(@account.entries.includes(:recorder).entered_on(from_date: @from_date, to_date: @to_date).order(entry_date: :desc).uniq)
        else
          @pagy, @entries = pagy(@account.entries.includes(:recorder).order(entry_date: :desc).uniq)
        end

        respond_to do |format|
          format.html
          format.pdf do
            pdf = AccountingModule::Accounts::EntriesReportPdf.new(
              entries: @account.entries.entered_on(from_date: @from_date, to_date: @to_date),
              account: @account,
              employee: current_user,
              from_date: @from_date,
              to_date: @to_date,
              view_context: view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Entries Report.pdf"
          end
        end
      end
    end
  end
end
