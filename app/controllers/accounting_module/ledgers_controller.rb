# frozen_string_literal: true 

module AccountingModule
  class LedgersController < ApplicationController
    def index 
      @assets = AccountingModule::Ledger.asset.arrange(order: :code)
      @liabilities = AccountingModule::Ledger.liability.arrange(order: :code)
      @equities = AccountingModule::Ledger.equity
      @revenues = AccountingModule::Ledger.revenue
      @expenses = AccountingModule::Ledger.expense
    end 
  end 
end 