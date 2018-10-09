module Employees
  class ReportsController < ApplicationController
    def index
      @employee = User.find(params[:employee_id])
      @date = params[:date] ? DateTime.parse(params[:date]) : Date.today.strftime("%B %e, %Y")
      respond_to do |format|
        format.html
        format.pdf do
          pdf = TransactionSummaryPdf.new(
            employee: @employee,
            date: @date,
            view_context: view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Report.pdf"
        end
      end
    end
  end
end
