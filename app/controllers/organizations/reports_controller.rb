module Organizations
  class ReportsController < ApplicationController
    def index
      @organization = Organization.find(params[:organization_id])
    end
  end
end
