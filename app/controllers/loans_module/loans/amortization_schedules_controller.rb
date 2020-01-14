module LoansModule
  module Loans
    class AmortizationSchedulesController < ApplicationController
      def index
        @loan = current_cooperative.loans.includes(:amortization_schedules).find(params[:loan_id])
        @amortization_schedules = @loan.amortization_schedules
        @employee = current_user
        respond_to do |format|
          format.html
          format.pdf do
            pdf = LoansModule::LoanAmortizationSchedulePdf.new(
              loan: @loan,
              amortization_schedules: @amortization_schedules,
              voucher: @loan.disbursement_voucher,
              employee: @employee,
              view_context: view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Amortization Schedule.pdf"
          end
        end
      end
    end
  end
end
