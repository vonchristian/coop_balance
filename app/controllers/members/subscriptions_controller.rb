module Members
  class SubscriptionsController < ApplicationController
    def index
      @programs = current_cooperative.programs
      @member = current_cooperative.member_memberships.find(params[:member_id])
    end
  end
end
