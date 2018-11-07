module LoansModule
  class SchedulesController < ApplicationController
    def index
      @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : Date.today
      @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : Date.today
      @amortization_schedules = current_cooperative.amortization_schedules.scheduled_for(from_date: @from_date, to_date: @to_date)
    end
    def show
      @employee = current_user
      @date = params[:id]
      @schedules = current_cooperative.amortization_schedules.scheduled_for(from_date: (Date.parse(@date).beginning_of_day), to_date: (Date.parse(@date).end_of_day))
      respond_to do |format|
        format.html
        format.pdf do
          pdf = LoansModule::SchedulePdf.new(@date, @schedules, @employee, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Schedule.pdf"
        end
      end
    end
  end
end
