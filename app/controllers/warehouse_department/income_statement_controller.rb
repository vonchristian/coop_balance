module WarehouseDepartment
  class IncomeStatementController < ApplicationController
    def index
      @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : DateTime.now.at_beginning_of_month
      @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : DateTime.now
      @revenues = AccountingDepartment::Revenue.warehouse_accounts
      @expenses = AccountingDepartment::Expense.warehouse_accounts

      respond_to do |format|
        format.html # index.html.erb
      end
    end
  end
end
