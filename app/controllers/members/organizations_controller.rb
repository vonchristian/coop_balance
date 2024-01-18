module Members
  class OrganizationsController < ApplicationController
    respond_to :html, :json

    def new
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @organization = @member.organization_memberships.build
      respond_modal_with @organization
    end

    def create
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @organization = Organizations::MembershipProcessing.new(
        organization_params.merge(
          organization_membership_id: @member.id,
          organization_membership_type: @member.class.name,
          cooperative_id: current_cooperative.id
        )
      )
      @organization.process!
      respond_modal_with @organization,
                         location: member_settings_url(@member)
    end

    private

    def organization_params
      params.require(:organizations_organization_member).permit(:organization_id)
    end
  end
end
