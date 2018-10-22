module Members
  class OrganizationsController < ApplicationController
    respond_to :html, :json

    def new
      @member = Member.find(params[:member_id])
      @organization = @member.organization_memberships.build
      respond_modal_with @organization
    end

    def create
      @member = Member.find(params[:member_id])
      @organization = @member.organization_memberships.create(organization_params)
      respond_modal_with @organization, 
        location: member_settings_url(@member), 
        notice: "Organization updated successfully."
    end

    private
    def organization_params
      params.require(:organizations_organization_member).permit(:organization_id)
    end
  end
end
