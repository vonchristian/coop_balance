module Organizations
  class LoansController < ApplicationController
    def index
      @organization = Organization.find(params[:organization_id])
      @loans = @organization.loans.disbursed.paginate(page: params[:page], per_page: 50)
      respond_to do |format|
        format.html
        format.pdf do
          pdf = Organizations::BillingStatementPdf.new(@organization, @loans, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Billing Statement.pdf"
        end
      end
    end
  end
end
