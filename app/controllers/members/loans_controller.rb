module Members
  class LoansController < ApplicationController
    def index
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @loans = @member.loans.includes(:loan_product, :disbursement_voucher).order(tracking_number: :desc).paginate(page: params[:page], per_page: 20)
      @loan_applications = @member.loan_applications.includes(:voucher, :loan_product).order("vouchers.reference_number DESC").paginate(page: params[:page], per_page: 20)
	    @loan_products = current_cooperative.loan_products
    end
  end
end
