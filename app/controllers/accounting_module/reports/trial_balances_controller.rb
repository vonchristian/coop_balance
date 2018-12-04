module AccountingModule
  module Reports
    class TrialBalancesController < ApplicationController
      def index
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Time.zone.now
        @accounts = current_cooperative.accounts.joins(:entries).active.order(:code).paginate(page: params[:page], per_page: 25)
        @cooperative = current_cooperative
        respond_to do |format|
          format.html
          format.xlsx
          format.pdf do
            pdf = AccountingModule::Reports::TrialBalancesPdf.new(
              accounts:     current_cooperative.accounts,
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
