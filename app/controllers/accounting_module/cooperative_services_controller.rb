module AccountingModule
  class CooperativeServicesController < ApplicationController
    def show
      @cooperative_service = current_cooperative.cooperative_services.find(params[:id])
      @pagy, @entries      = pagy(@cooperative_service.entries)
    end
  end
end
