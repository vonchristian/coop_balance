module Monitoring
  class ShareCapitalsController < ApplicationController
    def index
      @share_capitals = current_cooperative.share_capitals.paginate(page: params[:page], per_page: 25)
    end
  end
end
