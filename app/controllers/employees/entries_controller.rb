module Employees
  class EntriesController < ApplicationController
    def index 
      @employee = User.find(params[:employee_id])
      @from_date = params[:from_date] ? DateTime.parse(params[:from_date]).beginning_of_day : DateTime.now.beginning_of_day
      @to_date = params[:to_date] ? DateTime.parse(params[:to_date]).end_of_day : DateTime.now.end_of_day
      @entries = @employee.entries.entered_on(from_date: @from_date, to_date: @to_date).paginate(page: params[:page], per_page: 50)
      respond_to do |format| 
        format.html
        format.pdf do 
          pdf = AccountingModule::CollectionReportPdf.new(@entries, @employee, @from_date, @to_date, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Disbursement.pdf"
        end
      end 
    end 
    def show 
    end
  end 
end