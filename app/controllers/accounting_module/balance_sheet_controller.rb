module AccountingDepartment
  class BalanceSheetController < ApplicationController
    def index
      first_entry = AccountingDepartment::Entry.order('entry_date ASC').first
      @from_date = first_entry ? first_entry.entry_date : Time.zone.now
      @to_date = params[:entry_date] ? Date.parse(params[:entry_date]) : Time.zone.now
      @assets = AccountingDepartment::Asset.all
      @liabilities = AccountingDepartment::Liability.all
      @equity = AccountingDepartment::Equity.all

      respond_to do |format|
        format.html # index.html.erb
      end
    end
  end
end
