module ShareCapitalsSection
  class DashboardsController < ApplicationController
    def index
      @share_capitals = MembershipsModule::ShareCapital.all
    end
  end
end
