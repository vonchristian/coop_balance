class SchedulesController < ApplicationController
  def show
    @employee = current_user
    @schedule = LoansModule::AmortizationSchedule.find(params[:id])
    @schedules = LoansModule::AmortizationSchedule.
    scheduled_for(from_date: (Date.parse(@date).beginning_of_day), to_date: (Date.parse(@date).end_of_day)).
    paginate(page: params[:page], per_page: 25)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = SchedulePdf.new(@schedule, @employee, view_context)
        send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Schedule.pdf"
      end
    end
  end
end
