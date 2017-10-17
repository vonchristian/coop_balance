module LoansModule 
  class PaymentSchedulesController < ApplicationController
    def index 
      @payment_schedules = LoansModule::AmortizationSchedule.all 
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
  end 
end 