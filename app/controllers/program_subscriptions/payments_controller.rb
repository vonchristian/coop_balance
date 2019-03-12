module ProgramSubscriptions
  class PaymentsController < ApplicationController
    def new
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @program_subscription = current_cooperative.program_subscriptions.find(params[:program_subscription_id])
      @payment = ProgramSubscriptions::PaymentProcessing.new
    end
    def create
     @member = current_cooperative.member_memberships.find(params[:program_subscriptions_payment_processing][:member_id])
      @program_subscription = current_cooperative.program_subscriptions.find(params[:program_subscription_id])
      @payment = ProgramSubscriptions::PaymentProcessing.new(payment_params)
      if @payment.valid?
        @payment.save
        redirect_to program_subscription_voucher_url(program_subscription_id: @program_subscription.id, id: @payment.find_voucher.id), notice: "Subscription payment created successfully."
      else
        render :new
      end
    end

    private
    def payment_params
      params.require(:program_subscriptions_payment_processing).permit(:amount, :date, :employee_id, :reference_number, :cash_account_id, :program_subscription_id, :description, :account_number, :member_id)
    end
  end
end
