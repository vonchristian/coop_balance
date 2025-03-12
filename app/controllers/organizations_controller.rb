require "will_paginate/array"
class OrganizationsController < ApplicationController
  def index
    @organizations = if params[:search].present?
                       current_cooperative.organizations.text_search(params[:search]).paginate(page: params[:page], per_page: 25)
    else
                       current_cooperative.organizations.order(:abbreviated_name).paginate(page: params[:page], per_page: 25)
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
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @organization = current_cooperative.organizations.find(params[:id])
  end

  def update
    @organization = current_cooperative.organizations.find(params[:id])
    if @organization.update(organization_params)
      redirect_to organization_url(@organization), notice: "Organization updated successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @organization = current_cooperative.organizations.find(params[:id])
    @members = if params[:membership_type].present?
                 @organization.member_memberships.select { |m| m.current_membership.membership_type == params[:membership_type] }.paginate(page: params[:page], per_page: 25)
    elsif params[:search].present?
                 @organization.member_memberships.text_search(params[:search]).paginate(page: params[:page], per_page: 25)
    else
                 @organization.member_memberships.uniq.paginate(page: params[:page], per_page: 25)
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :abbreviated_name, :avatar)
  end
end
