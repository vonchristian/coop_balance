require 'will_paginate/array'
module Organizations
  class MembersController < ApplicationController
    def new
      @organization = Organization.find(params[:organization_id])
      @member = @organization.organization_members.build
      @members = (Member.all + User.all).paginate(page: params[:page], per_page: 50)
    end
    def create
      @organization = Organization.find(params[:organization_id])
      @member = @organization.organization_members.build(member_params)
      @member.save
      redirect_to new_organization_member_url(@organization), notice: "Member added successfully."
    end

    private
    def member_params
      params.require(:organization_member).permit(:member_id)
    end
  end
end
