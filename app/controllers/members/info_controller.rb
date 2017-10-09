module Members 
  class InfoController < ApplicationController
    def index 
      @member = Member.friendly.find(params[:member_id])
    end 
  end 
end 