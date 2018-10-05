require 'will_paginate/array'
class OrganizationsController < ApplicationController
  def index
    @organizations = Organization.all.paginate(page: params[:page], per_page: 25)
  end
  def new
    @organization = Organization.new
  end
  def create
    @organization = Organization.create(organization_params)
    if @organization.valid?
      @organization.save
      redirect_to organizations_url, notice: "Organization saved successfully."
    else
      render :new
    end
  end
  def show
    @organization = Organization.find(params[:id])
    if params[:search].present?
      @members = @organization.member_memberships.text_search(params[:search]).paginate(page: params[:page], per_page: 25)
    else
      @members = @organization.members.uniq.paginate(page: params[:page], per_page: 25)
    end
  end

  private
  def organization_params
    params.require(:organization).permit(:name, :avatar)
  end
end
