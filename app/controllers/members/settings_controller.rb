module Members
  class SettingsController < ApplicationController
    def index
      @member = Member.find(params[:member_id])
    end
  end
end
