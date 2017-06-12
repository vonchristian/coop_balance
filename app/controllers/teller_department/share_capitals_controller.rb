module TellerDepartment
  class ShareCapitalsController < ApplicationController
    def index
      @share_capitals = ShareCapital.all
    end
  end
end
