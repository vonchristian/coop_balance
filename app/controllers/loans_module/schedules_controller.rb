module LoansModule 
  class SchedulesController < ApplicationController 
    def index 
    end 
    def show 
      @employee = current_user
      @date = params[:id]
      @schedules = LoansModule::AmortizationSchedule.for((Date.parse(@date).beginning_of_day), (Date.parse(@date).end_of_day))
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