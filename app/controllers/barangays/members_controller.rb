module Barangays
  class MembersController < ApplicationController
    def index
      @barangay = Addresses::Barangay.find(params[:barangay_id])
      if params[:search].present?
        @members = @barangay.members.text_search(params[:search]).order(:last_name).uniq.paginate(page: params[:page], per_page: 35)
      else
        @members = @barangay.members.uniq.paginate(page: params[:page], per_page: 25)
      end
    end
  end
end
