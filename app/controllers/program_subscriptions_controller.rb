class ProgramSubscriptionsController < ApplicationController
  def show
    @program_subscription = current_cooperative.program_subscriptions.find(params[:id])
    @member = @program_subscription.subscriber
  end
end
