module Members
  class ProgramSubscriptionsController < ApplicationController
    def create
      @member = Member.find(params[:member_id])
      @program = CoopServicesModule::Program.find(params[:program_id])
      @member.program_subscriptions.find_or_create_by(program: @program)
      redirect_to member_subscriptions_url(@member), notice: "Subscribed successfully."
    end
  end
end
