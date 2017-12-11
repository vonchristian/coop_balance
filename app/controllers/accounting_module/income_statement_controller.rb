require 'chronic'
module AccountingModule
  class IncomeStatementController < ApplicationController
    def index
      @from_date = params[:from_date] ? Chronic.parse(params[:from_date]) : Date.today.at_beginning_of_month
      @to_date = params[:to_date] ? Chronic.parse(params[:to_date]) : Date.today
      @revenues = AccountingModule::Revenue.updated_at(from_date: @from_date, to_date: @to_date)
      @expenses = AccountingModule::Expense.updated_at(from_date: @from_date, to_date: @to_date)
      @employee = current_user

      respond_to do |format|
        format.html # index.html.erb
        format.pdf do
          pdf = IncomeStatementPdf.new(@revenues, @expenses, @employee, @from_date, @to_date, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Income Statement.pdf"
        end
      end
    end
  end
end
