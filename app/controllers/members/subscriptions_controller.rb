module Members
  class SubscriptionsController < ApplicationController
    def index
      @programs = CoopServicesModule::Program.all
      @member = Member.find(params[:member_id])
    end
  end
end
