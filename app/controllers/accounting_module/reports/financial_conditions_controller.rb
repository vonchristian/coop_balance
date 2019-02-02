module AccountingModule
  module Reports
    class FinancialConditionsController < ApplicationController
      def index
        @comparison = AccountingModule::FinancialConditionComparison.new
        first_entry = current_cooperative.entries.order('entry_date ASC').first
        @from_date = first_entry ? DateTime.parse(first_entry.entry_date.strftime("%B %e, %Y")) : Time.zone.now
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Time.zone.now.end_of_day
        @assets = current_cooperative.accounts.assets.active.order(:code).all
        @liabilities = current_cooperative.accounts.liabilities.active.order(:code).all
        @equities =current_cooperative.accounts.equities.active.order(:code).all
        @employee = current_user
        respond_to do |format|
          format.html
          format.pdf do
            pdf = AccountingModule::Reports::FinancialConditionPdf.new(
              from_date:    @from_date,
              to_date:      @to_date,
              assets:       @assets,
              liabilities:  @liabilities,
              equities:     @equities,
              employee:     @employee,
              view_context: view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Financial Statement.pdf"
          end
        end
      end
    end
  end
end
