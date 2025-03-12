module Employees
  class CashReceiptsController < ApplicationController
    def index
      @employee = current_cooperative.users.find(params[:employee_id])
      @from_date = params[:from_date] ? DateTime.parse(params[:from_date]).beginning_of_day : DateTime.now.beginning_of_day
      @to_date = params[:to_date] ? Chronic.parse(params[:to_date]) : DateTime.now.end_of_day
      @entries = @employee.cash_on_hand_account.debit_entries.entered_on(from_date: @from_date, to_date: @to_date)
      respond_to do |format|
        format.pdf do
          pdf = Employees::CashOnHandPdf.new(@entries, @employee, @from_date, @to_date, @title = "DAILY REGISTER OF CASH RECEIPT", view_context)
          send_data pdf.render, type: "application/pdf", disposition: "inline", file_name: "Cash Receipt Report.pdf"
        end
      end
    end
  end
end
