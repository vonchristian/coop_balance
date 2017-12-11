module AccountingModule
  class ReportsController < ApplicationController
    def index
      authorize [:accounting_module, :reports]
      @from_date = params[:from_date] ? Chronic.parse(params[:from_date]) : Date.today.at_beginning_of_month
      @to_date = params[:to_date] ? Chronic.parse(params[:to_date]) : Date.today
    end
  end
end
