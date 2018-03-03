module MembershipApplications
  class ContributionsController < ApplicationController
    def new
      @membership = Membership.find(params[:membership_application_id])
      @amount = Vouchers::VoucherAmount.new
    end
    def create
      @membership = Membership.find(params[:membership_application_id])
      @amount = Vouchers::VoucherAmount.create!(amount_params)
      @amount.save
      redirect_to new_membership_application_contribution_url(@membership), notice: "added successfully"
    end
    private
    def amount_params
      params.require(:vouchers_voucher_amount).permit(:amount, :amount_type, :description, :account_id, :commercial_document_id, :commercial_document_type)
    end
  end

end
