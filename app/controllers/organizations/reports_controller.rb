module Organizations
  class ReportsController < ApplicationController
    def index
      @organization = current_cooperative.organizations.find(params[:organization_id])
      @date = params[:date] ? Date.parse(params[:date]) : Date.today.strftime("%B %e, %Y")
      @membership_type = params[:membership_type]
      @loans_pdf = @organization.member_loans.disbursed.filter_by(membership_type: @membership_type, date: @date)
      @loans = @loans_pdf.paginate(page: params[:page], per_page: 50)
      @cooperative = current_user.cooperative
      
      respond_to do |format|
        format.html
        format.xlsx
        format.pdf do
          pdf = Organizations::BillingStatementPdf.new(@organization, @loans_pdf, @cooperative, @membership_type, @date, view_context)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Billing Statement.pdf"
        end
      end
    end
  end
end
