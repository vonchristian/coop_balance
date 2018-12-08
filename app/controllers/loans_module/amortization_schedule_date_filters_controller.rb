module LoansModule
  class AmortizationScheduleDateFiltersController < ApplicationController
    def index
      @from_date              = params[:from_date] ? DateTime.parse(params[:from_date]) : Date.today
      @to_date                = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today
      @amortization_schedules = current_cooperative.amortization_schedules.for_loans.scheduled_for(from_date: @from_date, to_date: @to_date)
    end
  end
end
