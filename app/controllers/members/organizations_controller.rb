module Members
  class OrganizationsController < ApplicationController
    def new
      @member = Member.find(params[:member_id])
      @organization = @member.organization_memberships.build
    end
    def create
      @member = Member.find(params[:member_id])
      @organization = @member.organization_memberships.create(organization_params)
      if @organization.valid?
        @organization.save
        redirect_to member_settings_url(@member), notice: "Organization updated successfully."
      else
        render :new
      end
    end

    private
    def organization_params
      params.require(:organizations_organization_member).permit(:organization_id)
    end
  end
end
