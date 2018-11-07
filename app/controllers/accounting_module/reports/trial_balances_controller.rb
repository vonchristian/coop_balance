module AccountingModule
  module Reports
    class TrialBalancesController < ApplicationController
      def index
        first_entry = current_cooperative.entries.order(entry_date:  :desc).first
        @from_date = first_entry ? DateTime.parse(first_entry.entry_date.strftime("%B %e, %Y")) : Date.today
        @to_date = params[:to_date] ? Chronic.parse(params[:to_date]) : Time.zone.now
        @accounts = current_cooperative.accounts.active.order(:code)
        @cooperative = current_cooperative
        respond_to do |format|
          format.html
          format.xlsx
          format.pdf do
            pdf = AccountingModule::Reports::TrialBalancesPdf.new(
              accounts:     @accounts,
              to_date:      @to_date,
              cooperative:  @cooperative,
              view_context: view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Trial Balance.pdf"
          end
        end
      end
    end
  end
end
