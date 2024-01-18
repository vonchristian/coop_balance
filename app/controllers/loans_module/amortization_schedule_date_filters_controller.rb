module LoansModule
  class AmortizationScheduleDateFiltersController < ApplicationController
    def index
      @from_date              = params[:from_date] ? DateTime.parse(params[:from_date]) : Time.zone.today
      @to_date                = params[:to_date] ? DateTime.parse(params[:to_date]) : Time.zone.today
      @amortization_schedules = current_cooperative
                                .amortization_schedules
                                .for_loans.scheduled_for(from_date: @from_date, to_date: @to_date)
                                .order(date: :asc)
      respond_to do |format|
        format.html
        format.xlsx
        format.pdf do
          pdf = LoansModule::AmortizationSchedulesPdf.new(
            from_date: @from_date,
            to_date: @to_date,
            amortization_schedules: @amortization_schedules,
            cooperative: current_cooperative,
            view_context: view_context
          )
          send_data pdf.render, type: 'application/pdf', disposition: 'inline', file_name: 'dasd.pdf'
        end
      end
    end
  end
end
