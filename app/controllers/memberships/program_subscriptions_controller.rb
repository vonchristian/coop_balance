module Memberships
  class ProgramSubscriptionsController < ApplicationController
    def create
      @program = current_cooperative.programs.find(params[:program_id])
      @membership = current_cooperative.memberships.find(params[:membership_id])
      @membership.program_subscriptions.find_or_create_by(program: @program)
      redirect_to member_subscriptions_url(@membership.cooperator), notice: 'subscribed successfully.'
    end
  end
end
