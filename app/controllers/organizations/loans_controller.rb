module Organizations
  class LoansController < ApplicationController
    def index
      @date = params[:date] ? Chronic.parse(params[:date]) : Date.today.strftime("%B %e, %Y")
      @organization = Organization.find(params[:organization_id])
      @loans = @organization.loans.disbursed.paginate(page: params[:page], per_page: 50)
      @cooperative = current_user.cooperative
      respond_to do |format|
        format.html
        format.xlsx
        format.pdf do
          pdf = Organizations::BillingStatementPdf.new(@organization, @loans, @cooperative, @date, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Billing Statement.pdf"
        end
      end
    end
  end
end
