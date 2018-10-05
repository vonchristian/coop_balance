require 'will_paginate/array'
module Organizations
  class MembersController < ApplicationController
    def new
      @organization = Organization.find(params[:organization_id])
      @member = @organization.organization_members.build
      if params[:search].present?
        @employee_members = User.text_search(params[:search])
        @member_members = Member.text_search(params[:search])
        @members = (@employee_members + @member_members).paginate(page: params[:page], per_page: 50)
      else
        @members = (Member.all + User.all).paginate(page: params[:page], per_page: 50)
      end
    end
    def create
      @organization = Organization.find(params[:organization_id])
      @member = @organization.organization_members.build(member_params)
      @member.save
      redirect_to new_organization_member_url(@organization), notice: "Member added successfully."
    end

    private
    def member_params
      params.require(:organizations_organization_member).permit(:organization_membership_id, :organization_membership_type)
    end
  end
end
