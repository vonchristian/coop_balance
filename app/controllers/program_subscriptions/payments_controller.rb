module ProgramSubscriptions
  class PaymentsController < ApplicationController
    def new
      @member = Member.find(params[:member_id])
      @program_subscription = MembershipsModule::ProgramSubscription.find(params[:program_subscription_id])
      @payment = Memberships::ProgramSubscriptions::PaymentProcessing.new
    end
    def create
     @member = Member.find(params[:memberships_program_subscriptions_payment_processing][:member_id])
      @program_subscription = MembershipsModule::ProgramSubscription.find(params[:program_subscription_id])
      @payment = Memberships::ProgramSubscriptions::PaymentProcessing.new(payment_params)
      if @payment.valid?
        @payment.save
        redirect_to member_subscriptions_url(@member), notice: "Subscription payment saved successfully."
      else
        render :new
      end
    end

    private
    def payment_params
      params.require(:memberships_program_subscriptions_payment_processing).permit(:amount, :date, :employee_id, :reference_number, :program_subscription_id, :member_id)
    end
  end
end
