module Employees
  class ReportsController < ApplicationController
    def index
      @employee = User.find(params[:employee_id])
      @date = params[:date] ? Chronic.parse(params[:date]) : Date.today
      respond_to do |format|
        format.html
        format.pdf do
          pdf = TellerReportPdf.new(@employee, @date, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Report.pdf"
        end
      end
    end
  end
end
