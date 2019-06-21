module AccountingModule
  module Settings
    class AccountingReportsController < ApplicationController
      def new
        @accounting_report = current_office.accounting_reports.build
      end

      def create
        @accounting_report = current_office.accounting_reports.create(report_params)
        if @accounting_report.valid?
          @accounting_report.save!
          redirect_to accounting_module_settings_url, notice: 'created successfully'
        else
          render :new
        end
      end

      private
      def report_params
        params.require(:accounting_module_accounting_report).
        permit(:title, :report_type)
      end
    end
  end
end
