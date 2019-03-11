module Employees
  module Reports
    class CashDisbursementsController < ApplicationController
      def index
        @employee = current_cooperative.users.find(params[:employee_id])
        @from_date = params[:from_date] ? Chronic.parse(params[:from_date]).beginning_of_day : DateTime.now.beginning_of_day
        @to_date = Chronic.parse(params[:to_date])
        @coop_service = params[:coop_service_id].present? ? current_cooperative.cooperative_services.find(params[:coop_service_id]) : nil
        @entries = @employee.cash_accounts.credit_entries.where(cooperative_service_id: params[:coop_service_id]).entered_on(from_date: @from_date, to_date: @to_date)
        respond_to do |format|
          format.pdf do
            pdf = CashBooks::DisbursementsPdf.new(
              entries: @entries,
              cooperative_service: @coop_service,
              employee: @employee,
              from_date: @from_date,
              to_date: @to_date,
              title: "Cash Disbursements Voucher",
              view_context: view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Cash Disbursement Report.pdf"
          end
        end
      end
    end
  end
end

