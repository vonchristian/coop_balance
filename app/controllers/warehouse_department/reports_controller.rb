module WarehouseDepartment
  class ReportsController < ApplicationController
    def balance_sheet
      first_entry = AccountingDepartment::Entry.order('entry_date ASC').first
      @from_date = first_entry ? first_entry.entry_date: Date.today
      @to_date = params[:entry_date] ? Date.parse(params[:entry_date]) : Date.today
      @assets = AccountingDepartment::Asset.all
      @liabilities = AccountingDepartment::Liability.all
      @equity = AccountingDepartment::Equity.all

      respond_to do |format|
        format.html # index.html.erb
      end
    end

    # @example
    #   GET /reports/income_statement
    def income_statement
      @from_date = params[:from_date] ? Date.parse(params[:from_date]) : Date.today.at_beginning_of_month
      @to_date = params[:to_date] ? Date.parse(params[:to_date]) : Date.today
      @revenues = AccountingDepartment::Revenue.all
      @expenses = AccountingDepartment::Expense.all

      respond_to do |format|
        format.html # index.html.erb
      end
    end
  end
end
