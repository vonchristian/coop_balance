module Employees
  module Reports
    class CashBookTransactionsController < ApplicationController
      def index
        @employee = current_cooperative.users.find(params[:employee_id])
        @from_date = params[:from_date] ? Chronic.parse(params[:from_date]).beginning_of_day : DateTime.now.beginning_of_day
        @to_date = Chronic.parse(params[:to_date])
        @entries = @employee.entries.with_cash_accounts.entered_on(from_date: @from_date, to_date: @to_date)
        respond_to do |format|
          format.pdf do
            pdf = CashBooks::TransactionsPdf.new(
              entries: @entries,
              employee: @employee,
              from_date: @from_date,
              to_date: @to_date,
              title: 'Cash Book Report',
              view_context: view_context
            )
            send_data pdf.render, type: 'application/pdf', disposition: 'inline', file_name: 'Cash Book Report.pdf'
          end
        end
      end
    end
  end
end
