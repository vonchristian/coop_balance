module Employees
  class InfoController < ApplicationController
    def index
      @employee = User.find(params[:employee_id])
      respond_to do |format|
        format.html
        format.pdf do
          pdf = Members::ReportPdf.new(@employee, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Member Report.pdf"
        end
      end
    end
  end
end
