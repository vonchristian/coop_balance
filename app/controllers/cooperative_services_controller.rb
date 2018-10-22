class CooperativeServicesController < ApplicationController
  respond_to :html, :json

  def index
    @cooperative_services = current_cooperative.cooperative_services
  end

  def new
    @cooperative_service = current_cooperative.cooperative_services.build
    respond_modal_with @cooperative_service
  end

  def create
    @cooperative_service = current_cooperative.cooperative_services.create(cooperative_service_params)
    respond_modal_with @cooperative_service, 
      location: management_module_settings_configurations_url, 
      notice: "Cooperative Service created successfully."
  end

  def show
    @cooperative_service = current_cooperative.cooperative_services.find(params[:id])
  end

  private
  def cooperative_service_params
    params.require(:coop_services_module_cooperative_service).
    permit(:title)
  end
end
