require 'chronic'
module AccountingModule
  module Reports
    class IncomeStatementsController < ApplicationController
      def index
        @from_date = params[:from_date].present? ? DateTime.parse(params[:from_date]) : current_cooperative.entries.order(entry_date: :desc).last.try(:entry_date)
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today
        @revenues = current_cooperative.accounts.revenues
        @expenses = current_cooperative.accounts.expenses
        @employee = current_user
        @office = @employee.office
        respond_to do |format|
          format.html # index.html.erb
          format.pdf do
            pdf = IncomeStatementPdf.new(
              revenues: @revenues,
              expenses: @expenses,
              employee: @employee,
              from_date: @from_date,
              to_date: @to_date,
              view_context: view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Income Statement.pdf"
          end
        end
      end
    end
  end
end
