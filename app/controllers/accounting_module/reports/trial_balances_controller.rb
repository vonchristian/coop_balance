module AccountingModule
  module Reports
    class TrialBalancesController < ApplicationController
      def index
        first_entry = AccountingModule::Entry.order('entry_date DESC').first
        @from_date = first_entry ? DateTime.parse(first_entry.entry_date.strftime("%B %e, %Y")) : Time.zone.now
        @to_date = params[:to_date] ? Chronic.parse(params[:to_date]) : Time.zone.now
        @accounts = AccountingModule::Account.updated_at(from_date: @from_date, to_date: @to_date)
        respond_to do |format|
          format.html
          format.xlsx
          format.pdf do
            pdf = AccountingModule::Reports::TrialBalancesPdf.new(@accounts, @to_date, view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Trial Balance.pdf"
          end
        end
      end
    end
  end
end
