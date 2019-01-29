module LoansModule
  module LoanApplications
    class AmortizationSchedulesController < ApplicationController
      def index
        @loan_application = current_cooperative.loan_applications.find(params[:loan_application_id])
        @amortization_schedules = @loan_application.amortization_schedules
        respond_to do |format|
          format.html
          format.pdf do
            pdf = LoansModule::LoanAmortizationSchedulePdf.new(
              loan:                   @loan_application,
              amortization_schedules: @amortization_schedules,
              employee:               current_user,
              voucher:                @loan_application.voucher,
              term:                   @loan_application.term,
              view_context:           view_context
            )
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Amortization Schedule.pdf"
          end
        end
      end
    end
  end
end
