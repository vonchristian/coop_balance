module WarehouseDepartment
  class BalanceSheetController < ApplicationController
    def index
      first_entry = AccountingDepartment::Entry.order('entry_date ASC').first
      @from_date = first_entry ? first_entry.entry_date: Date.today
      @to_date = params[:entry_date] ? Date.parse(params[:entry_date]) : Date.today
      @assets = AccountingDepartment::Asset.warehouse_accounts
      @liabilities = AccountingDepartment::Liability.warehouse_accounts
      @equity = AccountingDepartment::Equity.warehouse_accounts

      respond_to do |format|
        format.html # index.html.erb
      end
    end
  end
end
