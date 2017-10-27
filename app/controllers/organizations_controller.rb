class OrganizationsController < ApplicationController
  def index
    @organizations = Organization.all
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
  end

  private
  def organization_params
    params.require(:organization).permit(:name)
  end
end
