module WarehouseDepartment
  class IncomeStatementController < ApplicationController
    def index
      @from_date = params[:from_date] ? Date.parse(params[:from_date]) : Date.today.at_beginning_of_month
      @to_date = params[:to_date] ? Date.parse(params[:to_date]) : Date.today
      @revenues = AccountingDepartment::Revenue.warehouse_accounts
      @expenses = AccountingDepartment::Expense.warehouse_accounts

      respond_to do |format|
        format.html # index.html.erb
      end
    end
  end
end
