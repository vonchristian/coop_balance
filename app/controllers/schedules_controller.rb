class SchedulesController < ApplicationController
  def show
    @employee = current_user
    @schedule = LoansModule::AmortizationSchedule.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = SchedulePdf.new(@schedule, @employee, view_context)
        send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Schedule.pdf"
      end
    end
  end
end
