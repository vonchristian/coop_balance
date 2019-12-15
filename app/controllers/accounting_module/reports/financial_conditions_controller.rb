module AccountingModule
  module Reports
    class FinancialConditionsController < ApplicationController
      def index
        first_entry = current_cooperative.entries.order('entry_date ASC').first
        @from_date  = params[:from_date].present? ? DateTime.parse(params[:from_date]) : Date.current.beginning_of_year
        @to_date    = params[:to_date].present? ? DateTime.parse(params[:to_date]) : Date.current

        @employee   = current_user
        @office     = @employee.office

        respond_to do |format|
          format.html
          format.xlsx
          format.pdf do
            pdf = AccountingModule::Reports::FinancialConditionPdf.new(
              from_date:    @from_date,
              to_date:      @to_date,
              employee:     @employee,
              view_context: view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Financial Statement.pdf"
          end
        end
      end
    end
  end
end
