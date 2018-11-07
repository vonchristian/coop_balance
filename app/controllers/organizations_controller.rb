require 'will_paginate/array'
class OrganizationsController < ApplicationController
  def index
    if params[:search].present?
      @organizations = current_cooperative.organizations.text_search(params[:search]).paginate(page: params[:page], per_page: 25)
    else
      @organizations = current_cooperative.organizations.paginate(page: params[:page], per_page: 25)
    end
  end
  def new
    @organization = current_cooperative.organizations.new
  end
  def create
    @organization = current_cooperative.organizations.create(organization_params)
    if @organization.valid?
      @organization.save
      redirect_to organization_url(@organization), notice: "Organization saved successfully."
    else
      render :new
    end
  end
  def show
    @organization = current_cooperative.organizations.find(params[:id])
    if params[:search].present?
      @members = @organization.member_memberships.text_search(params[:search]).paginate(page: params[:page], per_page: 25)
    else
      @members = @organization.member_memberships.uniq.paginate(page: params[:page], per_page: 25)
    end
  end

  private
  def organization_params
    params.require(:organization).permit(:name, :avatar)
  end
end
