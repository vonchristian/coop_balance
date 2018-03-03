module Programs
  class PaymentsController < ApplicationController
    def new
      @member = Member.find(params[:subscriber_id])
      @program = MembershipsModule::ProgramSubscription.find(params[:program_id])
      @payment = ProgramSubscriptions::PaymentProcessing.new
    end
    def create
      @member = Member.find(params[:subscriber_id])
      @program = MembershipsModule::ProgramSubscription.find(params[:program_id])
      @payment = ProgramSubscriptions::PaymentProcessing.new(payment_params)
      if @payment.valid?
        @payment.save
        @member = Member.find_by(id: params[:subscriber_id])
        redirect_to member_subscriptions_url(member_id: @payment.subscriber_id), notice: "Subscription payment saved successfully."
      else
        render :new
      end
    end

    private
    def payment_params
      params.require(:programs_payment_processing).permit(:amount, :date, :recorder_id, :or_number, :program_id, :subscriber_id)
    end
  end
end
