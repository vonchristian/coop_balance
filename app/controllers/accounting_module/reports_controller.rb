module AccountingModule
  class ReportsController < ApplicationController
    def index
      authorize %i[accounting_module reports]
      @from_date = params[:from_date] ? Chronic.parse(params[:from_date]) : Time.zone.today.at_beginning_of_month
      @to_date = params[:to_date] ? Chronic.parse(params[:to_date]) : Time.zone.today
    end
  end
end
