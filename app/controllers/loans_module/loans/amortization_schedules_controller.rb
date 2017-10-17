module LoansModule 
  module Loans 
    class AmortizationSchedulesController < ApplicationController 
      def index 
        @loan = LoansModule::Loan.includes(:amortization_schedules).find(params[:loan_id])
        @amortization_schedules = @loan.amortization_schedules
        respond_to do |format|
          format.html
          format.pdf do 
            pdf = LoansModule::LoanAmortizationSchedulePdf.new(@loan, @amortization_schedules, view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Amortization Schedule.pdf"
          end
        end
      end 
    end 
  end 
end 