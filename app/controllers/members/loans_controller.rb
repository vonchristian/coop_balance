module Members
  class LoansController < ApplicationController
    def index
      @member            = current_cooperative.member_memberships.includes(:addresses).find(params[:member_id])
      @pagy, @loans             = pagy(@member.loans.not_cancelled.not_archived.includes(:loan_product, :disbursement_voucher, :term, :receivable_account => [:amounts]).order("vouchers.disbursement_date DESC"))
      @loan_applications = @member.loan_applications.not_cancelled.not_approved.includes(:voucher, :loan_product).order("vouchers.date DESC").paginate(page: params[:page], per_page: 20)
    end
  end
end
