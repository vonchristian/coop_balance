module Employees
  class BlottersController < ApplicationController
    def index
      @employee = current_user
      respond_to do |format|
        format.html
        format.pdf do
          pdf = Employees::BlotterPdf.new(employee: @employee, date: Time.zone.today, view_context: view_context)
          send_data pdf.render, type: 'application/pdf', disposition: 'inline', file_name: 'Disbursement.pdf'
        end
      end
    end
  end
end

