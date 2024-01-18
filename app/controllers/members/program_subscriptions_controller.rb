module Members
  class ProgramSubscriptionsController < ApplicationController
    def create
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @program = current_cooperative.programs.find(params[:program_id])
      @member.program_subscriptions.find_or_create_by(program: @program)
      redirect_to member_subscriptions_url(@member), notice: 'Subscribed successfully.'
    end
  end
end
