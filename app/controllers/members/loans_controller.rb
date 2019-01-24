module Members
  class LoansController < ApplicationController
    def index
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @loans = @member.loans.not_cancelled.not_archived.order(tracking_number: :desc).paginate(page: params[:page], per_page: 20)
      @loan_applications = @member.loan_applications.not_cancelled.includes(:voucher).order("vouchers.reference_number DESC").paginate(page: params[:page], per_page: 20)
	    @loan_products = current_cooperative.loan_products
    end
  end
end
