module Members
  class SubscriptionsController < ApplicationController
    def index
      @programs = CoopServicesModule::Program.all
      @member = Member.friendly.find(params[:member_id])
    end
    def create
      @program = CoopServicesModule::Program.find(params[:program_id])
      @member = Member.friendly.find(params[:member_id])
      @member.program_subscriptions.find_or_create_by(program: @program)
      redirect_to member_subscriptions_url(@member), notice: "subscribed successfully."
    end
  end
end
