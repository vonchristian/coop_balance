# frozen_string_literal: true 

module AccountingModule
  class LedgersController < ApplicationController
    def index 
      @from_date  = Date.current.year.years.ago
      @to_date    = params[:to_date] ? DateTime.parse(params[:to_date]).end_of_day : Date.current
  
      @assets = AccountingModule::Ledger.asset
      @liabilities = AccountingModule::Ledger.liability
      @equities = AccountingModule::Ledger.equity
      @revenues = AccountingModule::Ledger.revenue
      @expenses = AccountingModule::Ledger.expense
    end 

    def show 
      @ledger = AccountingModule::Ledger.find(params[:id])
    end
  end 
end 