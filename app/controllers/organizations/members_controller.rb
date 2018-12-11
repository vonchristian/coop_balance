require 'will_paginate/array'
module Organizations
  class MembersController < ApplicationController

    def new
      @organization = current_cooperative.organizations.find(params[:organization_id])
      @member = Organizations::MembershipProcessing.new(organization_id: @organization.id)
      if params[:search].present?
        @employee_members = User.text_search(params[:search])
        @member_members = Member.text_search(params[:search])
        @members = (@employee_members + @member_members).paginate(page: params[:page], per_page: 50)
      else
        @members = (Member.all + User.all).paginate(page: params[:page], per_page: 50)
      end
    end
    def create
      @organization = current_cooperative.organizations.find(params[:organization_id])
      @member = Organizations::MembershipProcessing.new(
        member_params.merge(
          organization_id: @organization.id,
          cooperative_id: current_cooperative.id
        )
      )
      @member.process!
      redirect_to new_organization_member_url(@organization), notice: "Member added successfully."
    end

    private
    def member_params
      params.require(:organizations_membership_processing).permit(:organization_membership_id, :organization_membership_type)
    end
  end
end
