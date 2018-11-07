module Reports
  class AuditReportsController < ApplicationController
    def index
      @employee = current_user
      @from_date = params[:from_date] ? DateTime.parse(params[:from_date]).beginning_of_day : DateTime.now.beginning_of_day
      @to_date = params[:to_date] ? Chronic.parse(params[:to_date]) : DateTime.now.end_of_day
      @entries = current_cooperative.entries.entered_on(from_date: @from_date, to_date: @to_date)
      respond_to do |format|
        format.html
        format.pdf do
          pdf = Reports::AuditReportPdf.new(@entries, @employee, @from_date, @to_date, @title="AUDIT REPORT", view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Audit Report.pdf"
        end
      end
    end
  end
end
