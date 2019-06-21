module AccountingModule
  module AccountingReports
    class SettingsController < ApplicationController
      def index
        @accounting_report = current_office.accounting_reports.find(params[:accounting_report_id])
      end
    end
  end
end
