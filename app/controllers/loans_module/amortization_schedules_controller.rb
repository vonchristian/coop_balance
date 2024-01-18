module LoansModule
  class AmortizationSchedulesController < ApplicationController
    def index
      @start_date = params[:start_date] ? DateTime.parse(params[:start_date]) : Time.zone.today.beginning_of_month
      @from_date  = params[:from_date]  ? DateTime.parse(params[:from_date]) : Time.zone.today
      @to_date    = params[:to_date] ? DateTime.parse(params[:to_date]) : Time.zone.today
      @amortization_schedules = current_office
                                .amortization_schedules
                                .for_loans
                                .not_cancelled.uniq
                                .scheduled_for(from_date: @start_date.beginning_of_month, to_date: @start_date.end_of_month)
    end

    def show
      @amortization_schedule = current_cooperative.amortization_schedules.find(params[:id])
    end
  end
end
