# frozen_string_literal: true

module AccountingModule
  class LedgersController < ApplicationController
    def index
      @from_date  = Date.current.year.years.ago
      @to_date    = params[:to_date] ? DateTime.parse(params[:to_date]).end_of_day : Date.current

      @assets = AccountingModule::Ledger.asset.includes(:running_balances)
      @liabilities = AccountingModule::Ledger.liability.includes(:running_balances)
      @equities = AccountingModule::Ledger.equity.includes(:running_balances)
      @revenues = AccountingModule::Ledger.revenue.includes(:running_balances)
      @expenses = AccountingModule::Ledger.expense.includes(:running_balances)
    end

    def show
      @ledger = AccountingModule::Ledger.find(params[:id])
    end
  end
end
