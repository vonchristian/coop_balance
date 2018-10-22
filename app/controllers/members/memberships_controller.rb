module Members
  class MembershipsController < ApplicationController
    respond_to :html, :json

    def new
      @member = Member.find(params[:member_id])
      @membership = @member.memberships.build
      respond_modal_with @membership
    end

    def create
      @member = Member.find(params[:member_id])
      @membership = @member.memberships.create(membership_params)
      respond_modal_with @membership, 
        location: member_settings_url(@member), 
        notice: "Membership saved successfully."
    end

    def edit
      @member = Member.find(params[:member_id])
      @membership = Membership.where(cooperative_id: params[:cooperative_id]).last
      respond_modal_with @membership
    end

    def update
      @member = Member.find(params[:member_id])
      @membership = Membership.find(params[:id])
      @membership.update(membership_params)
      respond_modal_with @membership, 
        location: member_settings_url(@member), 
        notice: "Membership updated successfully."
    end

    private
    def membership_params
      params.require(:membership).permit(:membership_type, :account_number, :cooperative_id, :membership_date)
    end
  end
end
