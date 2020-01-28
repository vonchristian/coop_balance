module AccountingModule
  class AccountingReportsController < ApplicationController
    def new 
      @accounting_report = current_office.accounting_reports.build 
    end 

    def create 
      @accounting_report = current_office.accounting_reports.create(accounting_report_params)
      if @accounting_report.valid?
        @accounting_report.save!
        redirect_to accounting_module_accounting_report_url(@accounting_report), notice: 'Report created successfully'
      else 
        render :new 
      end  
    end

    def show
      @to_date           = params[:to_date] ? Date.parse(params[:to_date]) : Date.current
      @accounting_report = current_office.accounting_reports.find(params[:id])
      respond_to do |format|
        format.html
        format.xlsx
        format.pdf do
          pdf = @accounting_report.pdf_renderer.new(
            to_date:      @to_date,
            report:       @report,
            office:       @accounting_report.office,
            level_three_asset_account_categories: @accounting_report.level_three_asset_account_categories,
            level_two_asset_account_categories: @accounting_report.level_two_asset_account_categories,
            level_one_asset_account_categories: @accounting_report.level_one_asset_account_categories,
            title: @accounting_report.title,

            view_context: view_context,
            cooperative:  current_cooperative)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Balance Sheet.pdf"
        end
      end
    end

    private 
    def accounting_report_params
      params.require(:accounting_module_accounting_report).
      permit(:title, :report_type)
    end 
  end
end
