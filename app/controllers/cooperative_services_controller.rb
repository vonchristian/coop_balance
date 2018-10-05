class CooperativeServicesController < ApplicationController
  def index
    @cooperative_services = current_cooperative.cooperative_services
  end
  def new
    @cooperative_service = current_cooperative.cooperative_services.build
  end
  def create
    @cooperative_service = current_cooperative.cooperative_services.create(cooperative_service_params)
    if @cooperative_service.valid?
      @cooperative_service.save
      redirect_to management_module_settings_configurations_url, notice: "Cooperative Service created successfully."
    else
      render :new
    end
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
