module TellerModule
  class ShareCapitalsController < ApplicationController
    def index
      @share_capitals = MembershipsModule::ShareCapital.all
    end
  end
end
