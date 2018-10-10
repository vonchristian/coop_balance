module CooperativeServices
  class EntriesController < ApplicationController
    def index
      @cooperative_service = current_cooperative.cooperative_services.
      find(params[:cooperative_service_id])
    end
  end
end
