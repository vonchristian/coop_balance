module Organizations
  class LoansController < ApplicationController
    def index
      @organization = Organization.find(params[:organization_id])
      respond_to do |format|
        format.html
        format.pdf do
          pdf = Organizations::BillingStatementPdf.new(@organization, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Billing Statement.pdf"
        end
      end
    end
  end
end
