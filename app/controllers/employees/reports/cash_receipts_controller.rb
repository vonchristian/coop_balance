module Employees
  module Reports
    class CashReceiptsController < ApplicationController
      def index
        @employee = current_cooperative.users.find(params[:employee_id])
        @from_date = params[:from_date] ? Chronic.parse(params[:from_date]).beginning_of_day : DateTime.now.beginning_of_day
        @to_date = Chronic.parse(params[:to_date])
        @entries = @employee.cash_accounts.debit_entries.entered_on(from_date: @from_date, to_date: @to_date)
        respond_to do |format|
          format.pdf do
            pdf = CashBooks::CashReceiptsPdf.new(
              entries: @entries,
              employee: @employee,
              from_date: @from_date,
              to_date: @to_date,
              title: "Cash Receipts Journal",
              view_context: view_context
            )
            send_data pdf.render, type: "application/pdf", disposition: "inline", file_name: "Cash Receipts Report.pdf"
          end
        end
      end
    end
  end
end
