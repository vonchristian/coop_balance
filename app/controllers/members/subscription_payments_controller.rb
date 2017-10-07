module Members 
  class SubscriptionPaymentsController < ApplicationController
    def new 
      @member = Member.friendly.find(params[:member_id])
      @payment = Programs::PaymentForm.new 
    end 
    def create 
      @payment = Programs::PaymentForm.new(payment_params)
      if @payment.valid?
        @payment.save 
        @member = Member.find_by(id: params[:member_id])
        redirect_to member_subscriptions_url(member_id: @payment.member_id), notice: "Subscription payment saved successfully."
      else 
        render :new 
      end 
    end 

    private 
    def payment_params
      params.require(:programs_payment_form).permit(:amount, :date, :recorder_id, :or_number, :program_id, :member_id)
    end
  end 
end 