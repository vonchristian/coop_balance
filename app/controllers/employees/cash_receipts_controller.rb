module Employees
  class CashReceiptsController < ApplicationController
    def index
      @employee = User.find(params[:employee_id])
      @from_date = params[:from_date] ? DateTime.parse(params[:from_date]).beginning_of_day : DateTime.now.beginning_of_day
      @to_date = Chronic.parse(params[:date])
      @entries = @employee.cash_on_hand_account.debit_entries.entered_on(from_date: @from_date, to_date: @to_date)
      respond_to do |format|
        format.pdf do
          pdf = Reports::CashOnHandPdf.new(@entries, @employee, @from_date, @to_date, @title="DAILY REGISTER OF CASH RECEIPT", view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Cash Receipt Report.pdf"
        end
      end
    end
  end
end

