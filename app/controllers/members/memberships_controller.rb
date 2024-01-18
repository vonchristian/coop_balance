module Members
  class MembershipsController < ApplicationController
    respond_to :html, :json

    def new
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @membership = @member.memberships.build
      respond_modal_with @membership
    end

    def create
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @membership = @member.memberships.create(membership_params)
      respond_modal_with @membership,
                         location: member_settings_url(@member),
                         notice: 'Membership saved successfully.'
    end

    def edit
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @membership = current_cooperative.memberships.where(cooperative: current_cooperative).last
      respond_modal_with @membership
    end

    def update
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @membership = current_cooperative.memberships.find(params[:id])
      @membership.update(membership_params)
      respond_modal_with @membership,
                         location: member_settings_url(@member),
                         notice: 'Membership updated successfully.'
    end

    private

    def membership_params
      params.require(:cooperatives_membership).permit(:membership_type, :account_number, :cooperative_id, :membership_date)
    end
  end
end
