module Barangays
  class ShareCapitalsController < ApplicationController
    def index
      @barangay = current_cooperative.barangays.find(params[:barangay_id])
      @share_capitals = @barangay.share_capitals.paginate(page: params[:page], per_page: 25)
    end
  end
end
