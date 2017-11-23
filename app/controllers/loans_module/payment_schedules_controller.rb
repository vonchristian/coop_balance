module LoansModule
  class PaymentSchedulesController < ApplicationController
    def index
      if params[:from_date].present? && params[:to_date].present?
         @from_date = Chronic.parse(params[:from_date])
        @to_date = Chronic.parse(params[:to_date])
        @payment_schedules = LoansModule::AmortizationSchedule.scheduled_for(from_date: @from_date, to_date: @to_date)
      else
        @payment_schedules = LoansModule::AmortizationSchedule.all
      end
    end
    def show
      @payment_schedule = LoansModule::AmortizationSchedule.find(params[:id])
      respond_to do |format|
        format.html
        format.pdf do
          pdf = LoansModule::AmortizationSchedulePdf.new(@payment_schedule, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Payment Schedule PDF.pdf"
        end
      end
    end
    def edit
      @payment_schedule = LoansModule::AmortizationSchedule.find(params[:id])
      @payment_schedule.notes.build
    end
    def update
      @payment_schedule = LoansModule::AmortizationSchedule.find(params[:id])
      @payment_schedule.update(payment_schedule_params)
      if @payment_schedule.save
        redirect_to loans_module_payment_schedule_url(@payment_schedule), notice: "Updated successfully"
      else
        render :edit
      end
    end

    private
    def payment_schedule_params
      params.require(:loans_module_amortization_schedule).permit(notes_attributes: [:content])
    end
  end
end
