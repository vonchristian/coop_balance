require 'chronic'
module AccountingModule
  module Reports
    class IncomeStatementsController < ApplicationController
      def index
        @from_date = AccountingModule::Entry.order(entry_date: :desc).last.try(:entry_date) || Date.today
        @to_date = params[:to_date] ? Chronic.parse(params[:to_date]) : Date.today
        @revenues = AccountingModule::Revenue.updated_at(from_date: @from_date, to_date: @to_date)
        @expenses = AccountingModule::Expense.updated_at(from_date: @from_date, to_date: @to_date)
        @employee = current_user

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
