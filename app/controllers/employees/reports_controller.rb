module Employees 
  class ReportsController < ApplicationController
    def index 
      @employee = User.find(params[:employee_id])
      respond_to do |format|
        format.html
        format.pdf do 
          pdf = TellerReportPdf.new(@employee, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Report.pdf"
        end
      end
    end 
  end 
end