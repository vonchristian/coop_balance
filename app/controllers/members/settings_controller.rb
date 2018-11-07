module Members
  class SettingsController < ApplicationController
    def index
      @member = current_cooperative.member_memberships.find(params[:member_id])
    end
  end
end
