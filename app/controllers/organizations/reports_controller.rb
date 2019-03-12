module Organizations
  class ReportsController < ApplicationController
    def index
      @organization = current_cooperative.organizations.find(params[:organization_id])
      @date = params[:date].present? ? Date.parse(params[:date]) : Date.today.strftime("%B %e, %Y")
      @membership_type = params[:membership_type].present? ? params[:membership_type] : Cooperatives::Membership.whitelisted_membership_types.first
      @loan_product = params[:loan_product].present? ? current_cooperative.loan_products.find(params[:loan_product]) : current_cooperative.loan_products.first
      @loans_pdf = @organization.member_loans.disbursed.filter_by(membership_type: @membership_type, date: @date, loan_product: @loan_product)
      @loans = @loans_pdf.paginate(page: params[:page], per_page: 50)
      @employee = current_user
      
      respond_to do |format|
        format.html
        format.xlsx
        format.pdf do
          pdf = Organizations::BillingStatementPdf.new(
            organization:    @organization, 
            employee:        @employee, 
            loan_product:    @loan_product, 
            loans_pdf:       @loans_pdf,  
            membership_type: @membership_type, 
            date:            @date, 
            view_context:     view_context
          )
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Billing Statement.pdf"
        end
      end
    end
  end
end
