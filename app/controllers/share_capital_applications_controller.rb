class ShareCapitalApplicationsController < ApplicationController
  def new
    @subscriber = params[:subscriber_type].constantize.find(params[:subscriber_id])
    @application = ShareCapitalApplicationProcessing.new
  end
end
