module AccountingModule
  module Reports
    class ComparativeFinancialConditionsController < ApplicationController
      def new
        @accounts = current_cooperative.accounts.active
        @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : Date.today
        @to_date   = params[:to_date]   ? DateTime.parse(params[:to_date])   : Date.today
      end
