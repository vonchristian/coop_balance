class ShareCapitalsController < ApplicationController
  def index
    @member = Member.find(params[:member_id])
  end
end
