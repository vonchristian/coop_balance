module AccountingModule
  class AccountingReportsController < ApplicationController
    def show
      @to_date = params[:to_date] ? Date.parse(params[:to_date]) : Date.current
      @report = current_office.accounting_reports.find(params[:id])
      respond_to do |format|
        format.html
        format.xlsx
        format.pdf do
          pdf = @report.pdf_renderer.new(
            to_date:      @to_date,
            report:       @report,

            view_context: view_context,
            cooperative:  current_cooperative)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Balance Sheet.pdf"
        end
      end
    end
  end
end
