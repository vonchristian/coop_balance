module AccountingModule
  module Reports
    class FinancialConditionsController < ApplicationController
      def index
        @comparison = AccountingModule::FinancialConditionComparison.new
        first_entry = current_cooperative.entries.order('entry_date ASC').first
        @from_date = first_entry ? DateTime.parse(first_entry.entry_date.strftime("%B %e, %Y")) : Time.zone.now
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Time.zone.now.end_of_day
        @assets = current_office.accounts.assets.order(:code).all.uniq
        @liabilities = current_office.accounts.liabilities.order(:code).all.uniq
        @equities = current_office.accounts.equities.order(:code).all.uniq
        @employee = current_user
        respond_to do |format|
          format.html
          format.xlsx
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
