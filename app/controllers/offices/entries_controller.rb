module Offices
  class EntriesController < ApplicationController
    def index
      @office = current_cooperative.offices.find(params[:office_id])
      @entries = @office.entries.order(entry_date: :desc).paginate(page: params[:page], per_page: 25)
    end
  end
end
